// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var submitPageMode

function showLogin() {
  if (submitPageMode == "login") {
    return
  } else if (submitPageMode == "submit") {
    Effect.SlideUp('submit', { duration: 0.5 }); 
  }
  Effect.SlideDown('login-form', { duration: 0.5 })

  submitPageMode = "login"
}

function showSubmit() {
  if (submitPageMode == "submit") {
    return
  } else if (submitPageMode == "login") {
    Effect.SlideUp('login-form', { duration: 0.5 }); 
  }
  Effect.SlideDown('submit', { duration: 0.5 })
  submitPageMode = "submit"
}
