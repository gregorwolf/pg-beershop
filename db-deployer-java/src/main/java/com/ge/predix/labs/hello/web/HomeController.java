package com.ge.predix.labs.hello.web;

import org.springframework.context.annotation.ComponentScan;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * 
 * @author Sergey.Vyatkin@ge.com
 */
@ComponentScan
@RestController
public class HomeController {
	
	public HomeController() {
		super();
	}

	/**
	 * @param echo
	 *            - the string to echo back
	 * @return - Java Predix.io - Hello World Example
	 */
	
	@SuppressWarnings("nls")
	@RequestMapping("/")
	public String index(
			@RequestParam(value = "echo", defaultValue = "echo") String echo) {
		return "Java Predix.io - Hello World Example";
	}
	

}