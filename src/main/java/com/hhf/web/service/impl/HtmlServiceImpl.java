package com.hhf.web.service.impl;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.util.Map;

import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.view.freemarker.FreeMarkerConfigurer;

import com.hhf.web.service.IHtmlService;

import freemarker.template.Configuration;
import freemarker.template.Template;

@Service("htmlService")
public class HtmlServiceImpl implements IHtmlService{

	 @Autowired
	  private FreeMarkerConfigurer freeMarkerConfigurer;

	  public void all(String templateName,Map<String, ?> rootMap) throws Exception {
	    process(templateName, rootMap);
	  }

	  public void process(String templateName, Map<String, ?> rootMap)
	      throws Exception {
	    Configuration configuration = freeMarkerConfigurer.getConfiguration();
	    Template template = configuration.getTemplate(templateName+".jsp");
	    File file = new File("d:/"+templateName+".html");
	    File parent = file.getParentFile(); 
	    if(parent!=null&&!parent.exists()){ 
	    parent.mkdirs(); 
	    } 
	    Writer out = new OutputStreamWriter(new FileOutputStream(file), "UTF-8");
	    template.process(rootMap, out);
	    IOUtils.closeQuietly(out);

	  }

}
