package com.example.messagingstompwebsocket;

public class Greeting {

  private String content;
  private String token;

  public Greeting() {
  }

  public Greeting(String content) {
    this.content = content;
  }

  public String getToken() {
	return token;
}

public void setToken(String token) {
	this.token = token;
}

public void setContent(String content) {
	this.content = content;
}

public Greeting(String content, String token) {
	super();
	this.content = content;
	this.token = token;
}

public String getContent() {
    return content;
  }

}