package com.hhf.web.util;

import java.io.IOException;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.TagSupport;

import com.hhf.common.mybatis.Page;

public class PageTag extends TagSupport {
	private static final long serialVersionUID = 6349370307595637390L;
	
	private Page<?> page;
	private String name;
	private String formId;
	
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getFormId() {
		return formId;
	}

	public void setFormId(String formId) {
		this.formId = formId;
	}

	public Page<?> getPage() {
		return page;
	}

	public void setPage(Page<?> page) {
		this.page = page;
	}

	@Override
	public int doStartTag() throws JspException {
		//获取分页bean
		JspWriter out = this.pageContext.getOut();
		
		//分页的html代码
		StringBuffer pageHtml = new StringBuffer();
		
		pageHtml.append("<div class=\"paging\">");
		if(page.getCurrentPageNo() == 1){
			pageHtml.append("<span class=\"pageup disabled\"><i>&lt;&nbsp;</i>上一页</span>");
		}else{
			pageHtml.append("<span class=\"pageup\" onclick=\""+this.name+"("+page.getPrevPageNo()+");\"><i>&lt;&nbsp;</i>上一页</span>");
		}
		pageHtml.append("<ul>");
		//页数小于7页
		if(page.getTotalPage() <=7){
			for(int i=0;i<page.getTotalPage();i++){
				if(page.getCurrentPageNo() == (i+1)){
					pageHtml.append("<li class=\"on\"><a href=\"javascript:;\">"+(i+1)+"</a></li>");
				}else{
					pageHtml.append("<li><a href=\"javascript:;\" onclick=\""+this.name+"("+(i+1)+");\">"+(i+1)+"</a></li>");
				}
			}
		}
		//页数大于7页
		else{
			if(page.getCurrentPageNo() == 1){
				pageHtml.append("<li class=\"on\"><a href=\"javascript:;\">1</a></li>");
			}else{
				pageHtml.append("<li><a href=\"javascript:;\" onclick=\""+this.name+"(1);\">1</a></li>");
			}
			
			if((page.getCurrentPageNo()-1 > 3) && (page.getLastPageNo() - page.getCurrentPageNo() > 3)){
				pageHtml.append("<li><span>...</span></li>");
				pageHtml.append("<li><a href=\"javascript:;\" onclick=\""+this.name+"("+(page.getCurrentPageNo()-2)+");\">"+(page.getCurrentPageNo()-2)+"</a></li>");
				pageHtml.append("<li><a href=\"javascript:;\" onclick=\""+this.name+"("+(page.getCurrentPageNo()-1)+");\">"+(page.getCurrentPageNo()-1)+"</a></li>");
				pageHtml.append("<li><span class=\"on\">"+page.getCurrentPageNo()+"</span></li>");
				pageHtml.append("<li><a href=\"javascript:;\" onclick=\""+this.name+"("+(page.getCurrentPageNo()+1)+");\">"+(page.getCurrentPageNo()+1)+"</a></li>");
				pageHtml.append("<li><a href=\"javascript:;\" onclick=\""+this.name+"("+(page.getCurrentPageNo()+2)+");\">"+(page.getCurrentPageNo()+2)+"</a></li>");
				pageHtml.append("<li><span>...</span></li>");
			}else if(page.getLastPageNo() - page.getCurrentPageNo() <= 3){
				pageHtml.append("<li><span>...</span></li>");
				for(int i=5;i>0;i--){
					if(page.getCurrentPageNo() == (page.getLastPageNo()-i)){
						pageHtml.append("</ul>");
						pageHtml.append("<span class=\"pagedown disabled\">下一页<i>&nbsp;&gt;</i></span>");
					}else{
						pageHtml.append("<li><a href=\"javascript:;\" onclick=\""+this.name+"("+(page.getLastPageNo()-i)+");\">"+(page.getLastPageNo()-i)+"</a></li>");
					}
					
				}
			}else if(page.getCurrentPageNo()-1 <= 3){
				for(int i=2;i<7;i++){
					if(page.getCurrentPageNo() == i){
						pageHtml.append("<li class=\"on\"><a a href=\"javascript:;\">"+i+"</a></li>");
					}else{
						pageHtml.append("<li><a href=\"javascript:;\" onclick=\""+this.name+"("+i+");\">"+i+"</a></li>");
					}
				}
				pageHtml.append("<li><span>...</span></li>");
			}
			if(page.getCurrentPageNo() == page.getLastPageNo()){
				pageHtml.append("<li class=\"on\"><a href=\"javascript:;\">"+page.getLastPageNo()+"</a></li>");
			}else{
				pageHtml.append("<li><a href=\"javascript:;\" onclick=\""+this.name+"("+page.getLastPageNo()+");\">"+page.getLastPageNo()+"</a></li>");
			}
			
		}
		if(page.getCurrentPageNo() == page.getLastPageNo()){
			pageHtml.append("</ul>");
			pageHtml.append("<span class=\"pagedown disabled\">下一页<i>&nbsp;&gt;</i></span>");
		}else{
			pageHtml.append("</ul>");
			pageHtml.append("<span class=\"pagedown\"><a href=\"javascript:;\" onclick=\""+this.name+"("+page.getNextPageNo()+");\" >下一页<i>&nbsp;&gt;</i></a></span>");
		}
		pageHtml.append("<p class=\"goto\">");
		pageHtml.append("<span>到第</span><input type=\"text\" name=\""+this.name+"page-num\" class=\"input\"><span>页</span>");
		pageHtml.append("<button class=\"btn btn-def sm\" onclick=\""+this.name+"Skip()\">确定</button>");
		pageHtml.append("</p>");
		pageHtml.append("</div>");
		
		
		pageHtml.append("<script>");
		pageHtml.append("function "+this.name+"(selectPageNo){");
		pageHtml.append("$(\"#"+this.formId+"\").append('<input type=\"hidden\" name=\"currentPageNo\" value=\"'+selectPageNo+'\" />');");
		pageHtml.append("$(\"#"+this.formId+"\").submit();");
		
		pageHtml.append("}");
		pageHtml.append("function "+this.name+"Skip(){");
		pageHtml.append("var selectPageNo = $(\"input[name="+this.name+"page-num]\").val();");
		pageHtml.append("if(!selectPageNo){");
		pageHtml.append("	alert(\"请输入页码！\");return;");
		pageHtml.append("}else{");
		pageHtml.append("	if(!/^\\d+$/.exec(selectPageNo)){");
		pageHtml.append("		alert(\"页码不正确！\");return;");
		pageHtml.append("	}");
		pageHtml.append("	if(selectPageNo <= 0 || selectPageNo > "+this.page.getLastPageNo()+"){");
		pageHtml.append("		alert(\"该页码不存在！\");return;");
		pageHtml.append("	}");
		pageHtml.append("}");
		pageHtml.append(this.name+"(selectPageNo)");
		pageHtml.append("}");
		pageHtml.append("</script>");
		try {
			out.print(pageHtml.toString());
		} catch (IOException e) {
			e.printStackTrace();
		}
		return super.doStartTag();
	}
	
	@Override
	public int doEndTag() throws JspException {
		return super.doEndTag();
	}
}
