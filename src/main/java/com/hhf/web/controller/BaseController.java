package com.hhf.web.controller;

import java.io.Serializable;
import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.concurrent.TimeUnit;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.hhf.common.mybatis.Page;
import com.hhf.constants.product.ProductConstants;
import com.hhf.model.product.Brand;
import com.hhf.model.product.BrandShow;
import com.hhf.model.product.BrandShowDetail;
import com.hhf.model.product.Product;
import com.hhf.model.product.Sku;
import com.hhf.param.product.SkuSpec;
import com.hhf.param.product.SkuSpecVal;
import com.hhf.service.product.IBrandService;
import com.hhf.service.product.IBrandShowService;
import com.hhf.service.product.IProductService;
import com.hhf.web.service.IHtmlService;
import com.alibaba.dubbo.common.utils.StringUtils;
import com.alibaba.fastjson.JSON;

@Controller
public class BaseController {
	
	@Autowired
	private IHtmlService htmlService;
	
	@Autowired
	private IBrandShowService brandShowService;
	
	@Autowired
	private IProductService   productService;
	
	@Autowired
	private IBrandService   brandService;
	
	@Autowired
	private RedisTemplate<String, Serializable> redis;
	
	@RequestMapping(value = "/create")
	@ResponseBody
	public String all(HttpServletRequest request, HttpServletResponse response) {
		
		BrandShow record=new BrandShow();
		java.util.List<BrandShow> List = this.brandShowService.getValidBrandShows(record);
		
	    String msg = request.getParameter("msg");
	    System.out.println("*********msg***" + List.size());
	    try {
	    	Map<String, String> pmap = new HashMap<String,String>();
	    	pmap.put("title", "this is test");
	    	pmap.put("content", "this is test content.");
	         this.htmlService.all("ftl/test",pmap);

	    } catch (Exception e) {
	      e.printStackTrace();
	      return "0";
	    }
	    return "1";
	  }
    
	@RequestMapping(value = "/brandshows")
     public String index(HttpServletRequest request,Model model, HttpServletResponse response){
		BrandShow record=new BrandShow();
//		DateFormat format1 = new SimpleDateFormat("yyyy-MM-dd");
//      String s = format1.format(new Date());
		String s = "online";
        List<BrandShow> list =new ArrayList<BrandShow>();
        
        try{
        if(this.redis.opsForValue().size("bs"+s)==0){
        	list = this.brandShowService.getValidBrandShows(record);
        	this.redis.opsForValue().set("bs"+s, (Serializable)list,3600*2, TimeUnit.SECONDS);
        }else{
        	list = (List<BrandShow>)this.redis.opsForValue().get("bs"+s);
        } 
        }catch (Exception e){
        	list = this.brandShowService.getValidBrandShows(record);
		}
        
        
		if(list!=null&&list.size()>0){
			List<BrandShow> list_del= new ArrayList<BrandShow>();
			Date now_time = new Date();
			for(BrandShow item:list){
				Integer bsid = item.getBrandShowId();
				Date b_date = item.getEndDate();
				if(null==b_date||b_date.before(now_time)){					
					list_del.add(item);
				}
				if(item.getBrandId()!=null){
					Integer bradndId = item.getBrandId();
					Brand brand = this.brandService.getByBrandId(new Long(bradndId));//todo
					if(brand!=null){
						item.setShowBannerImg(brand.getLogoUrl());
					}
				}
				BigDecimal lowestPrice=new BigDecimal(0.00);
				 try{
				        if(this.redis.opsForValue().size("lowestp"+bsid)==0){
				        	lowestPrice = this.brandShowService.getLowestPrice(bsid);
				        	this.redis.opsForValue().set("lowestp"+s, (Serializable)lowestPrice,3600*2, TimeUnit.SECONDS);
				        }else{
				        	lowestPrice = (BigDecimal) this.redis.opsForValue().get("lowestp"+bsid);
				        } 
				        }catch (Exception e){
				        	 lowestPrice = this.brandShowService.getLowestPrice(bsid);
						}
				
				if(lowestPrice!=null){
					item.setLowestPrice(lowestPrice);
				}else{
					item.setLowestPrice(new BigDecimal("0.00"));
				}
			}
			list.removeAll(list_del);
		}
		model.addAttribute("showlist", list);
    	 return "brandshow/index";
     }
	
	@RequestMapping(value = "/bsdetails")
	public String showDetail(@RequestParam(value="pageno", required=false, defaultValue="1") int pageNo,Long bsid,HttpServletRequest request,Model model, HttpServletResponse response){
		if(bsid==null){			
			return "";
		}
		Page<BrandShowDetail> page=new Page<BrandShowDetail>();
		Page<BrandShowDetail> ret=new Page<BrandShowDetail>();
		page.setPageSize(20);
		page.setCurrentPageNo(pageNo);
		Map<String,Object> map=new HashMap<String,Object>();
		 try{
		        if(this.redis.opsForValue().size("bsdpage"+bsid+"p"+pageNo)==0){
		        	map.put("bsid", bsid);
		    		ret = this.brandShowService.getBrandShowDetailByPage(map, page);
		    		this.redis.opsForValue().set("bsdpage"+bsid+"p"+pageNo, (Serializable)ret,3600*2, TimeUnit.SECONDS);
		        }else{
		        	ret = (Page<BrandShowDetail>)this.redis.opsForValue().get("bsdpage"+bsid+"p"+pageNo);
		        } 
		        }catch (Exception e){
		        	map.put("bsid", bsid);
		    		ret = this.brandShowService.getBrandShowDetailByPage(map, page);
				}
		
		model.addAttribute("showdetails", ret.getResult());
		model.addAttribute("pageno", ret.getCurrentPageNo());
		model.addAttribute("pagetotal",ret.getTotalPage());
		return "brandshow/bsdetail";
	}
    
	@RequestMapping(value = "/brandshow")
	public String brandShow(Integer bsid,HttpServletRequest request,Model model, HttpServletResponse response){
		if(bsid==null){
			return "redirect:/index.jsp";
		}
		BrandShow brandShow = this.brandShowService.getBrandShowById(bsid);
		if(brandShow==null){
			return "redirect:/index.jsp";
		}
		model.addAttribute("brandShow",brandShow);
		return "active";
	}
	
	@RequestMapping(value = "/detail")
	public String detail(Integer bsdid,HttpServletRequest request,Model model, HttpServletResponse response){
		if(bsdid==null){			
			return "redirect:/index.jsp";
		}
		
		Map<String,Object> map=new HashMap<String,Object>();
		model.addAttribute("bsdid", bsdid);
		BrandShowDetail bsd = this.brandShowService.getBrandShowDetailById(bsdid);
		if(bsd==null){
			return "redirect:/index.jsp";
		}
		BrandShow brandshow = this.brandShowService.getBrandShowById(bsd.getBrandShowId());
		if(brandshow==null){
			return "redirect:/index.jsp";
		}
		model.addAttribute("bsdetail", bsd);
		model.addAttribute("brandshow", brandshow);
		Integer skuId = bsd.getSkuId();
		Sku sku = this.productService.getSkuById(skuId);
		if(sku==null){
			return "redirect:/index.jsp";
		}
		model.addAttribute("sku", sku);
		model.addAttribute("skujson",JSON.toJSONString(sku));
	    Integer prodId = sku.getProdId();
	    Product product = this.productService.getProductById(prodId);
	    if(product==null){
			return "redirect:/index.jsp";
		}
	    model.addAttribute("product", product);
	    List<Sku> skus = new ArrayList<Sku>();
	    Map<String, SkuSpec> prductSpecs=new TreeMap<String, SkuSpec>();
	    Map<String, Sku> skuMapJson = new TreeMap<String,Sku>();
	    List<BrandShowDetail> bsds;
		//List<BrandShowDetail> bsds = this.brandShowService.getBrandShowDetailsByProdId(brandshow.getBrandShowId(), prodId);
	    try{
	        if(this.redis.opsForValue().size("bsdprods"+brandshow.getBrandShowId()+"p"+prodId)==0){
	        	bsds = this.brandShowService.getBrandShowDetailsByProdId(brandshow.getBrandShowId(), prodId);
	    		this.redis.opsForValue().set("bsdprods"+brandshow.getBrandShowId()+"p"+prodId,(Serializable)bsds,3600*2, TimeUnit.SECONDS);
	        }else{
	        	bsds = (List<BrandShowDetail>) this.redis.opsForValue().get("bsdprods"+brandshow.getBrandShowId()+"p"+prodId);
	        } 
	        }catch (Exception e){
	        	bsds = this.brandShowService.getBrandShowDetailsByProdId(brandshow.getBrandShowId(), prodId);
			}
	    if(bsds==null||bsds.size()==0){
	    	return "redirect:/index.jsp";
	    }
	    for(BrandShowDetail bsd_loop : bsds){
	    	BrandShowDetail bsd_temp=this.brandShowService.getBrandShowDetailById(bsd_loop.getbSDId());
	    	Sku sku_temp = this.productService.getSkuById(bsd_loop.getSkuId());
             
			if (bsd_temp.getSaleAmount()==null) {
				sku_temp.setStockBalance(bsd_temp.getShowBalance());
	        }else{
	        	if(bsd_temp.getShowBalance()==null){
	        		return "redirect:/index.jsp";
	        	}else{
	        		sku_temp.setStockBalance(bsd_temp.getShowBalance()-bsd_temp.getSaleAmount());
	        	}
	        	
	        }
			sku_temp.setSalePrice(bsd_temp.getShowPrice());
			sku_temp.setMarketPrice(bsd_temp.getOrgPrice());
			String SkuSpecIds = sku_temp.getSkuSpecId();
			String skuSpecNames=sku_temp.getSkuSpecName();
			this.getSpecMap(skuSpecNames,SkuSpecIds,prductSpecs);			
			skuMapJson.put(sku_temp.getSkuSpecId(), sku_temp);
			skus.add(sku_temp);
			Integer sku_cur_id = sku.getSkuId();
			Integer sku_temp_id = sku_temp.getSkuId();
			if(sku_cur_id.compareTo(sku_temp_id)==0){
				model.addAttribute("sku", sku_temp);
				model.addAttribute("skujson",JSON.toJSONString(sku_temp));
			}
	    }
	    if(skus==null||skus.size()==0){
			return "redirect:/index.jsp";
		}
	    model.addAttribute("skus", skus);
	    model.addAttribute("skusjson", JSON.toJSONString(skuMapJson));
	    model.addAttribute("prductSpecs", prductSpecs);
	    model.addAttribute("pspecsjson", JSON.toJSONString(prductSpecs));
		return "detail";
	}
	


	
	private void getSpecMap(String specNames,String specIds,Map<String, SkuSpec> prductSpecs) {
		
		if (!StringUtils.isBlank(specNames)&&!StringUtils.isBlank(specIds)) {
			String[] names = specNames.split("\\|\\|\\|");
			String[] ids = specIds.split("\\|\\|\\|");
				for(int i = 0;i<ids.length;i++){
					String name = names[i];
					String id = ids[i];
					String[] opt_name = name.split("\\:\\:\\:");
					String[] opt_id= id.split("\\:\\:\\:");
					String key=opt_id[0];
					SkuSpec skuSpec=new SkuSpec();
					if(prductSpecs.containsKey(key)){
						skuSpec=prductSpecs.get(key);
					}else{
						skuSpec.setSpecId(opt_id[0]);
						skuSpec.setSpecName(opt_name[0]);
						Map<String, SkuSpecVal> specVals=new HashMap<String, SkuSpecVal>();
						skuSpec.setSpecVals(specVals);
						
					}					
					SkuSpecVal skuSpecVal =new SkuSpecVal();
					skuSpecVal.setSpecId(opt_id[1]);
					skuSpecVal.setSpecName(opt_name[1]);
					Map<String, SkuSpecVal> specVals = skuSpec.getSpecVals();
					if(!specVals.containsKey(skuSpecVal.getSpecId())){
						specVals.put(skuSpecVal.getSpecId(), skuSpecVal);
						skuSpec.setSpecVals(specVals);
					}
					prductSpecs.put(key, skuSpec);					
				}
			}

	}
}