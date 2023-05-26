package com.example.messagingstompwebsocket;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.util.HtmlUtils;

@Controller
public class GreetingController {

  @MessageMapping("/hello")
  @SendTo("/topic/greetings")
  public Greeting greeting(HelloMessage message) throws Exception {
	  System.out.println(message.getToken());
    Thread.sleep(1000); // simulated delay
    Greeting gr = new Greeting();
    gr.setContent("Hello, " + HtmlUtils.htmlEscape(message.getName()) + "!");
    gr.setToken(message.getToken());
    return gr;
  }
  
  @RequestMapping("/chat")
  String Chat(Model m) {
	  return "index";
  }
  
  @RequestMapping("/token-12e544f")
  String Chat2(Model m) {
	  return "token";
  }

}