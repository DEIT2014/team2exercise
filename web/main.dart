// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'dart:core';
import 'dart:async';
import 'package:route_hierarchical/client.dart';
import 'dart:convert' show JSON;
import 'package:jsonx/jsonx.dart';
import 'package:team2exercise/stuscores.dart';
import 'package:team2exercise/teacherWord.dart';
import 'package:team2exercise/Assignment.dart';
import 'package:team2exercise/testResult.dart';
var localhost = "127.0.0.1:14080";

InputElement signin_userid; //登录界面的ID变量
InputElement signin_password; //登录界面的密码变量
InputElement signup_username; //注册界面的用户名变量
SelectElement signup_class; //注册界面的班级变量
InputElement signup_userid; //注册界面的用户ID变量
InputElement signup_password; //注册界面的密码变量
InputElement signup_confirmpw; //注册界面确认密码的变量
var test_word; //学生听写写入的单词
int tag;//标记该单词是否被教师选择为新任务中的单词
var newWordList=[];//新任务单词
var  wordlist=[];
var unfinishedTask = []; //学生首页界面未完成任务
String studentName;
String studentID;
String teacherName;
String teacherClass;
String studentClass;
String chosenTaskStuTest;//选择的任务单元
String chosenTaskTeaView;//选择查看成绩的任务单元
void main() {
  /// 登录界面
  document
      .querySelector('#SignIn_Div_Form')
      .style
      .display = "block";
  signin_userid = querySelector('#SignIn_UserID'); //输入用户ID
  signin_password = querySelector('#SignIn_Password'); //输入密码
  var router = new Router(useFragment: true);
  router.root..addRoute(
      name: 'signup', path: '/signup', enter: SignUp)..addRoute(
      name: 'home', path: '/', enter: (_) => null);
  querySelector('#SignUp_Btn').attributes['href'] = router.url('signup');
  router.listen();
  querySelector("#SignIn_Btn").onClick.listen(SignIn);
  querySelector("#review_test").onClick.listen(reviewTest);//复习界面的测试按钮
  /// 注册界面
  signup_username = querySelector('#SignUp_Username'); //输入用户名
  signup_class = querySelector('#SignUp_Class'); //输入班级
  signup_password = querySelector('#SignUp_Password'); //输入密码
  signup_confirmpw = querySelector('#SignUp_ConfirmPW'); //确认密码
  signup_userid = querySelector("#userID"); //用户ID
  var SignUp_Stu_Btn = querySelector('#SignUp_Stu_Btn'); //学生注册按钮
  SignUp_Stu_Btn.onClick.listen(StuSignUp);
  querySelector('#SignUp_Tea_Btn').onClick.listen(TeaSignUp); //教师注册按钮

  /// 注册成功界面
  querySelector('#SucSignUp_Btn')
    ..onClick.listen(ReturnSignIn); //返回登录界面按钮

  /// 教师主界面
  /// 待定
  querySelector('#newTask').onClick.listen(newTask);
  /// 布置任务界面
  var AssignWork_Btn=querySelector('#AssignWord_Btn');
  AssignWork_Btn.onClick.listen(SubmitWork); // 提交任务按钮

  /// 任务完成情况界面
  querySelector('#Ftask_Btn')
    ..onClick.listen(ftaskDiv);
  querySelector('#Teacher_Btn')
    ..onClick.listen(ReturnTeacher2); //返回教师主界面按钮

  /// 布置任务界面
  querySelector('#AssignWork_Btn')
    ..text = '提交'
    ..onClick.listen(SubmitWork); // 提交作业按钮

}

///登录

/// 用来接受用户点击登录按钮以后的响应工作：发送获取用户信息的请求
void SignIn(MouseEvent event) {
  //todo 记录输入的用户名和密码并与数据库进行比较，
  //todo 若对比成功，隐藏登录界面，显示教师或者学生界面（根据相应的标志值判断）
  var request = HttpRequest.getString("http://127.0.0.1:14080/userinfo").then(
      onSignIn);
}
///登录界面：对获取到的数据进行处理，与用户输入的内容进行对比，并进行相应的错误提示或创建路由
void onSignIn(responseText) {
  //var jsonString ='{"Userinfo":[{"Username": "wang", "Password": "3882", "Class": "class9", "Status": "stu"},{"Username": "jiang", "Password": "6712", "Class": "class6", "Status": "tea"}]}';
  //var userinfo=JSON.decode(MapAsJson);
//  var userinfolist=userinfo["Userinfo"];
  var jsonString = responseText;
  var userinfo = JSON.decode(jsonString);
  var userinfolist = userinfo["Userinfo"];
  int a = 0;
  print(signin_userid.value);
  for (var x in userinfolist) {
    print(x["Username"]);
    if (x["UserID"] == signin_userid.value) {
      print(x["Password"]);
      if (x["Password"] == signin_password.value) {
        print(x["Status"]);
        if (x["Status"] == "stu") {
          //隐藏登录转到学生界面
          var router1 = new Router(useFragment: true);
          router1.root
            ..addRoute(
                name: 'stu_signin', path: '/stu/index', enter: StuSignIn);
          querySelector('#SignIn_Btn').attributes['href'] =
              router1.url('stu_signin');
          router1.listen();
          a = 1;
          studentName=x["Username"];
          studentClass=x["Class"];
          studentID=x["UserID"];
          querySelector("#studentClass").text=studentClass;
          querySelector("#studentName").text=studentName;
          querySelector("#studentClass1").text=studentClass;
          querySelector("#studentName1").text=studentName;
          querySelector("#studentClass2").text=studentClass;
          querySelector("#studentName2").text=studentName;
        }
        else {
          //隐藏登录转到教师界面
          var router2 = new Router(useFragment: true);
          router2.root
            ..addRoute(
                name: 'tea_signin', path: '/tea/index', enter: TeaSignIn);
          querySelector('#SignIn_Btn').attributes['href'] =
              router2.url('tea_signin');
          router2.listen();
          a = 1;
          teacherClass=x["Class"];
          teacherName=x["Username"];
          querySelector("#teacherClass").text=teacherClass;
          querySelector("#teacherName").text=teacherName;
          querySelector("#teacherClass1").text=teacherClass;
          querySelector("#teacherName1").text=teacherName;
          querySelector("#teacherClass2").text=teacherClass;
          querySelector("#teacherName2").text=teacherName;
          querySelector('#teacherNameView').text=teacherName;
          querySelector('#teacherClassView').text=teacherClass;
        }
      }
    }
  }
  if (a == 0) {
    querySelector("#SignIn_Error").text = "学号、工号或者密码错误，请重新登录";
  }
}


///注册

///显示注册界面
void SignUp(RouteEvent e) {
  document
      .querySelector('#SignUp_Div_Form')
      .style
      .display = "block";
  document
      .querySelector('#SignIn_Div_Form')
      .style
      .display = "none";
}
/// 接受用户点击学生注册按钮的响应
void StuSignUp(MouseEvent event) {
  //todo 将数据写入数据库中的用户信息表，并将身份属性值设为stu
  //todo 显示注册成功界面
  var SignUpUserName = signup_username.value;
  var SignUpClass = signup_class.value;
  var SignUpPassword = signup_password.value;
  var SignUpConPassword = signup_confirmpw.value;
  var SignUpUserID = signup_userid.value;
  //if判断语句：用户名和密码是否为空，空时给出提示
  if (SignUpUserName == '' || SignUpPassword == '' || SignUpConPassword == '' ||
      SignUpUserID == '') {
    querySelector("#signuperror").text = "用户名、学号和密码不能为空！";
  }
  //else:对数据进行处理
  else {
    //if判断语句：密码和确认密码是否一致，不一致时给出提示（else语句在下面）
    if (signup_password.value == signup_confirmpw.value) {
      Map data = {
        "Username":'${SignUpUserName}',
        "Class":'${SignUpClass}',
        "Password":'${SignUpPassword}',
        "UserID":'${ SignUpUserID}'
      };
      var jsonData = JSON.encode(data);
      //创建post的request
      HttpRequest request = new HttpRequest(); //create a new XHR=XMLHttpRequest
      //创建一个事件处理器，等到request被处理好之后，返回response时调用
      request.onReadyStateChange.listen((_) {
        //if条件：状态改变
        if (request.readyState == HttpRequest.DONE &&
            (request.status == 200 || request.status == 0)) {
          //if判断语句：注册是否成功，成功跳转到另一个url处，否则给出错误提示：该用户已经注册......
          if (request.responseText == 'success') {
            var router2 = new Router(useFragment: true);
            router2.root
              ..addRoute(
                  name: 'SStuSignUp',
                  path: '/stu/signup/succeed',
                  enter: SSignUp);
            querySelector('#SignUp_Stu_Btn').attributes['href'] =
                router2.url('SStuSignUp');
            router2.listen();
          }
          else {
            querySelector("#signuperror").text = "该用户已注册，请更换学号";
          }
          //end 注册是否成功的if
        }
      });
      //post data to the server
      var url = "http://127.0.0.1:14080/student_signup";
      request.open("POST", url, async: false);
      request.send(jsonData); //perform the post

    }
    //else：两次密码不同，给出提示
    else {
      querySelector("#signuperror").text = "两次输入密码不同，请重新输入！";
    }
    //end 两次密码是否一致的if
  }
  //end 用户名和密码是否为空的if
}
/// 接受用户点击教师注册按钮的响应
void TeaSignUp(MouseEvent event) {
  //todo 将数据写入数中的用户信息表，并将身份属性值设为tea
  //todo 显示注册成功界面
  var SignUpUserName = signup_username.value;
  var SignUpClass = signup_class.value;
  var SignUpPassword = signup_password.value;
  var SignUpConPassword = signup_confirmpw.value;
  var SignUpUserID = signup_userid.value;
  //if判断语句：用户名和密码是否为空，空时给出提示
  if (SignUpUserName == '' || SignUpPassword == '' || SignUpConPassword == '' ||
      SignUpUserID == '') {
    querySelector("#signuperror").text = "用户名、工号和密码不能为空！";
  }
  //else:对数据进行处理
  else {
    //if判断语句：密码和确认密码是否一致，不一致时给出提示（else语句在下面）
    if (signup_password.value == signup_confirmpw.value) {
      Map data = {
        "Username":'${SignUpUserName}',
        "Class":'${SignUpClass}',
        "Password":'${SignUpPassword}',
        "UserID":'${SignUpUserID}'
      };
      var jsonData = JSON.encode(data);
      //创建post的request
      HttpRequest request = new HttpRequest(); //create a new XHR=XMLHttpRequest
      //创建一个事件处理器，等到request被处理好之后，返回response时调用
      request.onReadyStateChange.listen((_) {
        //if条件：状态改变
        if (request.readyState == HttpRequest.DONE &&
            (request.status == 200 || request.status == 0)) {
          //if判断语句：注册是否成功，成功跳转到另一个url处，否则给出错误提示：该用户已经注册......
          if (request.responseText == 'success') {
            var router2 = new Router(useFragment: true);
            router2.root
              ..addRoute(
                  name: 'STeaSignUp',
                  path: '/tea/signup/succeed',
                  enter: SSignUp);
            querySelector('#SignUp_Tea_Btn').attributes['href'] =
                router2.url('STeaSignUp');
            router2.listen();
          }
          else {
            querySelector("#signuperror").text = "该用户已注册，请更换工号";
          }
          //end 注册是否成功的if
        }
      });
      //post data to the server
      var url = "http://127.0.0.1:14080/teacher_signup";
      request.open("POST", url, async: false);
      request.send(jsonData); //perform the post

    }
    //else：两次密码不同，给出提示
    else {
      querySelector("#signuperror").text = "两次输入密码不同，请重新输入！";
    }
    //end 两次密码是否一致的if
  }
  //end 用户名和密码是否为空的if
}
///注册成功后，显示注册成功界面
void SSignUp(RouteEvent e) {
  document
      .querySelector('#Background_Soe')
      .style
      .display = "block";
  document
      .querySelector('#SignUp_Div_Form')
      .style
      .display = "none";
}
/// 注册成功界面的返回登录界面按钮：创建路由
void ReturnSignIn(MouseEvent event) {
  //todo 隐藏注册界面和注册成功界面，显示登录界面
  var router = new Router(useFragment: true);
  router.root
    ..addRoute(name: 'returnSignIn', path: '', enter: returnSignIn);
  querySelector('#SucSignUp_Btn').attributes['href'] = router.url('returnSignIn');
  router.listen();
}
///显示登录界面，隐藏注册界面
void returnSignIn(RouteEvent e) {
  document
      .querySelector('#SignIn_Div_Form')
      .style
      .display = "block";
  document
      .querySelector('#Background_Soe')
      .style
      .display = "none";
}



///学生界面部分

///显示学生主界面并且发送获取测试任务数据的请求
void StuSignIn(RouteEvent e) {
  document
      .querySelector('#student')
      .style
      .display = "block";
  document
      .querySelector('#SignIn_Div_Form')
      .style
      .display = "none";
  querySelector('#show_useinfo').text='姓名：$studentName    班级：$studentClass';
  var request = HttpRequest.getString(
      "http://127.0.0.1:14080/student/index").then(onStudentIndex);
}
///处理显示测试任务数据
void onStudentIndex(responseText) {
  var jsonString = responseText;
  var studentTask = JSON.decode(jsonString);
  Element toAddA = querySelector("#assignment");
  int j = 0;
  for (var i = 1; i <= (studentTask.length); i++) {
    if (studentTask[i - 1]["Class"] == studentClass) {
      String unfished;
      unfished = studentTask[i - 1]["assignmentID"];
      if (!(unfinishedTask.contains(unfished))) {
        unfinishedTask.add(unfished);
        Element toadd = querySelector("#assignment$j");
        toadd.text = unfinishedTask[j];
        if (j <= ((studentTask.length) / 2)+1) {
          var newA = new Element.a();
          int m = j + 1;
          newA.setAttribute("id", "assignment$m");
          newA.setAttribute("class", "assignment");
          toAddA.children.add(newA);
          j++;
        }
      }
    }
  }
  querySelector("#assignment0").onClick.listen(studentTest0);
  querySelector("#assignment1").onClick.listen(studentTest1);
  querySelector("#assignment2").onClick.listen(studentTest2);
  querySelector("#assignment3").onClick.listen(studentTest3);
  querySelector("#assignment4").onClick.listen(studentTest4);
  querySelector("#assignment5").onClick.listen(studentTest5);
}

///点击任务按钮跳转到相应的url，即跳转到复习界面
void studentTest0(MouseEvent event) {
  chosenTaskStuTest=querySelector('#assignment0').text;
  var router = new Router(useFragment: true);
  router.root
    ..addRoute(
        name: 'StuTest',
        path: '/stu/test',
        enter: StuTest0);
  querySelector('#assignment0').attributes['href'] =
      router.url('StuTest');
  router.listen();
}
///显示复习界面并发送获取单词的请求
void StuTest0(RouteEvent e) {
  document
      .querySelector('#student')
      .style
      .display = "none";
  document
      .querySelector('#review')
      .style
      .display = "block";
  var request = HttpRequest.getString("http://127.0.0.1:14080/review").then(
      ontaskWord0);
}
///复习界面：处理显示获得的单词数据
void ontaskWord0(responseText) {
  var jsonString = responseText;
  var taskWord = JSON.decode(jsonString);
  Assignment assignment = new Assignment();
  int i = 0;
  for (Map x in taskWord) {
    if (x["assignmentID"] == unfinishedTask[0]) {
      querySelector("#review_word$i").text = x["word"];
      DivElement toAdd = querySelector("#review_word$i");
      DivElement newDiv = new DivElement();
      int j = i + 1;
      newDiv.setAttribute("id", "review_word$j");
      toAdd.children.add(newDiv);
      i++;
    }
  }
}

///同上，第二个任务的触发事件
void studentTest1(MouseEvent event) {
  chosenTaskStuTest=querySelector('#assignment1').text;
  var router = new Router(useFragment: true);
  router.root
    ..addRoute(
        name: 'StuTest',
        path: '/stu/test',
        enter: StuTest1);
  querySelector('#assignment1').attributes['href'] =
      router.url('StuTest');
  router.listen();
}
void StuTest1(RouteEvent e) {
  document
      .querySelector('#student')
      .style
      .display = "none";
  document
      .querySelector('#review')
      .style
      .display = "block";
  var request = HttpRequest.getString("http://127.0.0.1:14080/review").then(
      ontaskWord1);
}
void ontaskWord1(responseText) {
  var jsonString = responseText;
  var taskWord = JSON.decode(jsonString);
  Assignment assignment = new Assignment();
  int i = 0;
  for (Map x in taskWord) {
    if (x["assignmentID"] == unfinishedTask[1]) {
      querySelector("#review_word$i").text = x["word"];
      DivElement toAdd = querySelector("#review_word$i");
      DivElement newDiv = new DivElement();
      int j = i + 1;
      newDiv.setAttribute("id", "review_word$j");
      toAdd.children.add(newDiv);
      i++;
    }
  }}

///同上，第三个任务的触发事件
void studentTest2(MouseEvent event) {
  chosenTaskStuTest=querySelector('#assignment2').text;
  var router = new Router(useFragment: true);
  router.root
    ..addRoute(
        name: 'StuTest',
        path: '/stu/test',
        enter: StuTest2);
  querySelector('#assignment2').attributes['href'] =
      router.url('StuTest');
  router.listen();
}
void StuTest2(RouteEvent e) {
  document
      .querySelector('#student')
      .style
      .display = "none";
  document
      .querySelector('#review')
      .style
      .display = "block";
  var request = HttpRequest.getString("http://127.0.0.1:14080/review").then(
      ontaskWord2);
}
void ontaskWord2(responseText) {
  var jsonString = responseText;
  var taskWord = JSON.decode(jsonString);
  Assignment assignment = new Assignment();
  int i = 0;
  for (Map x in taskWord) {
    if (x["assignmentID"] == unfinishedTask[2]) {
      querySelector("#review_word$i").text = x["word"];
      DivElement toAdd = querySelector("#review_word$i");
      DivElement newDiv = new DivElement();
      int j = i + 1;
      newDiv.setAttribute("id", "review_word$j");
      toAdd.children.add(newDiv);
      i++;
    }
  }
}

///同上，第四个任务的触发事件
void studentTest3(MouseEvent event) {
  chosenTaskStuTest=querySelector('#assignment3').text;
  var router = new Router(useFragment: true);
  router.root
    ..addRoute(
        name: 'StuTest',
        path: '/stu/test',
        enter: StuTest3);
  querySelector('#assignment3').attributes['href'] =
      router.url('StuTest');
  router.listen();
}
void StuTest3(RouteEvent e) {
  document
      .querySelector('#student')
      .style
      .display = "none";
  document
      .querySelector('#review')
      .style
      .display = "block";
  var request = HttpRequest.getString("http://127.0.0.1:14080/review").then(
      ontaskWord3);
}
void ontaskWord3(responseText) {
  var jsonString = responseText;
  var taskWord = JSON.decode(jsonString);
  Assignment assignment = new Assignment();
  int i = 0;
  for (Map x in taskWord) {
    if (x["assignmentID"] == unfinishedTask[3]) {
      querySelector("#review_word$i").text = x["word"];
      DivElement toAdd = querySelector("#review_word$i");
      DivElement newDiv = new DivElement();
      int j = i + 1;
      newDiv.setAttribute("id", "review_word$j");
      toAdd.children.add(newDiv);
      i++;
    }
  }}

///同上，第五个任务的触发事件
void studentTest4(MouseEvent event) {
  chosenTaskStuTest=querySelector('#assignment4').text;
  var router = new Router(useFragment: true);
  router.root
    ..addRoute(
        name: 'StuTest',
        path: '/stu/test',
        enter: StuTest4);
  querySelector('#assignment4').attributes['href'] =
      router.url('StuTest');
  router.listen();
}
void StuTest4(RouteEvent e) {
  document
      .querySelector('#student')
      .style
      .display = "none";
  document
      .querySelector('#review')
      .style
      .display = "block";
  var request = HttpRequest.getString("http://127.0.0.1:14080/review").then(
      ontaskWord4);
}
void ontaskWord4(responseText) {
  var jsonString = responseText;
  var taskWord = JSON.decode(jsonString);
  Assignment assignment = new Assignment();
  int i = 0;
  for (Map x in taskWord) {
    if (x["assignmentID"] == unfinishedTask[4]) {
      querySelector("#review_word$i").text = x["word"];
      DivElement toAdd = querySelector("#review_word$i");
      DivElement newDiv = new DivElement();
      int j = i + 1;
      newDiv.setAttribute("id", "review_word$j");
      toAdd.children.add(newDiv);
      i++;
    }
  }}

///同上，第六个任务的触发事件
void studentTest5(MouseEvent event) {
  chosenTaskStuTest=querySelector('#assignment5').text;
  var router = new Router(useFragment: true);
  router.root
    ..addRoute(
        name: 'StuTest',
        path: '/stu/test',
        enter: StuTest5);
  querySelector('#assignment5').attributes['href'] =
      router.url('StuTest');
  router.listen();
}
void StuTest5(RouteEvent e) {
  document
      .querySelector('#student')
      .style
      .display = "none";
  document
      .querySelector('#review')
      .style
      .display = "block";
  var request = HttpRequest.getString("http://127.0.0.1:14080/review").then(
      ontaskWord5);
}
void ontaskWord5(responseText) {
  var jsonString = responseText;
  var taskWord = JSON.decode(jsonString);
  Assignment assignment = new Assignment();
  int i = 0;
  for (Map x in taskWord) {
    if (x["assignmentID"] == unfinishedTask[5]) {
      querySelector("#review_word$i").text = x["word"];
      DivElement toAdd = querySelector("#review_word$i");
      DivElement newDiv = new DivElement();
      int j = i + 1;
      newDiv.setAttribute("id", "review_word$j");
      toAdd.children.add(newDiv);
      i++;
    }
  }}

//复习界面的测试按钮：创建路由
void reviewTest(MouseEvent event){
  DivElement testWordListDiv=querySelector('#testword_list');
  testWordListDiv.children.clear();
  var router = new Router(useFragment: true);
  router.root
    ..addRoute(
        name: 'StuReviewTest',
        path: '/stu/review/test',
        enter: StuReviewTest);
  querySelector('#review_test').attributes['href'] =
      router.url('StuReviewTest');
  router.listen();
}
///显示学生测试界面并发送获取单词信息的请求
void StuReviewTest(RouteEvent e) {
  document
      .querySelector('#review')
      .style
      .display = "none";
  document
      .querySelector('#test')
      .style
      .display = "block";
  querySelector('#studentTestName').text=studentName;
  querySelector('#studentTestClass').text=studentClass;
  var request=HttpRequest.getString('http://127.0.0.1:14080/test/get').then(
      showTestWord);
  querySelector("#test_submit").onClick.listen(testSubmit);
}
///测试界面：对获取到的单词数据进行处理并展示中文，以便默写
void showTestWord(responseText){
  List testWordList=JSON.decode(responseText);
  int num=1;
  DivElement testWordListDiv=querySelector('#testword_list');
  for(var testWord in testWordList){
    if(testWord['assignmentID']==chosenTaskStuTest){
      String word=testWord["word"];
      String chinese=testWord["chinese"];
      DivElement chineseDiv=new DivElement();
      chineseDiv.setAttribute('id','v${num}_chinese');
      chineseDiv.text=chinese;
      testWordListDiv.children.add(chineseDiv);
      InputElement testInput=new InputElement();
      testInput.setAttribute('id','testInput${num}');
      testInput.setAttribute('name','${word}');
      chineseDiv.children.add(testInput);
      num++;
    }
  }
}
///测试界面的提交按钮的触发事件：将测试结果写入数据库，发送请求，并且创建跳转到成绩界面的路由
void testSubmit(MouseEvent event){
  DivElement wordTestListDiv=querySelector('#testword_list');//获取单词列表外的大的div
  List divElement=wordTestListDiv.children;//获取该div下的所有单词div
  int num=1;
  List<Map> wordResultMapList=[];
  //对这些div中的input获取数据、构造成绩结果的map数据
  for(var child in divElement){
    List<InputElement> wordInputList=child.children;
    InputElement wordInput=wordInputList[0];
    String wordWritten=wordInput.value;
    String correctWord=wordInput.name;
    Map wordResultMap={
      'class':studentClass,
      'userID':studentID,
      'assignmentID':chosenTaskStuTest,
      'word':correctWord,
      'wordResult':wordWritten
    };
    if(wordWritten!=correctWord){
      wordResultMap.putIfAbsent('result',()=>'错误');
    }
    else{
      wordResultMap.putIfAbsent('result',()=>'正确');
    }
    wordResultMapList.add(wordResultMap);
  }
  var jsonData = JSON.encode(wordResultMapList);
  //创建post的request
  HttpRequest request = new HttpRequest(); //create a new XHR=XMLHttpRequest
  //创建一个事件处理器，等到request被处理好之后，返回response时调用
  request.onReadyStateChange.listen((_) {
    //if条件：状态改变
    if (request.readyState == HttpRequest.DONE &&
        (request.status == 200 || request.status == 0)) {
      print('success!');
    }
  });
  //post data to the server
  var url = "http://127.0.0.1:14080/student_test/post";
  request.open("POST", url, async: false);
  request.send(jsonData); //perform the post
  //获取结果数据
  var router = new Router(useFragment: true);
  router.root
    ..addRoute(
        name: 'StuTestSubmit',
        path: '/stu/test/submit',
        enter: StuTestSubmit);
  querySelector('#test_submit').attributes['href'] =
      router.url('StuTestSubmit');
  router.listen();

}
///跳转到成绩界面，并且发送获取结果数据的请求
void StuTestSubmit(RouteEvent e) {
  document.querySelector('#review').style.display='none';
  document
      .querySelector('#test')
      .style
      .display = "none";
  document
      .querySelector('#result')
      .style
      .display = "block";
  var request2 = HttpRequest.getString("http://127.0.0.1:14080/result").then(
      ontestResult);
  querySelector('#result_return')
    ..text = '返回主页'
    ..onClick.listen(result_return);
}
///成绩界面：对获取到的数据操作显示
void ontestResult(responseText) {
  var jsonString = responseText;
  var testResultList = JSON.decode(jsonString);
  testResult testResult1=new testResult();
  int right=0;
  int wrong=0;
  for (Map x in testResultList) {
    if ((x["userID"] == studentID) &&(x["assignmentID"]== chosenTaskStuTest)) {
      if(x["Result"]=="错误"){
        querySelector("#result_wrong_word$wrong").text ="正确单词："+ x["word"];
        querySelector("#result_wrong$wrong").text="你的单词"+x["wordResult"];
        DivElement toAdd = querySelector("#result_wrong$wrong");
        DivElement newDiv1 = new DivElement();
        DivElement newDiv2=new DivElement();
        int j = wrong + 1;
        newDiv1.setAttribute("id", "result_wrong$j");
        newDiv2.setAttribute("id","result_wrong_word$j");
        toAdd.children.add(newDiv2);
        toAdd.children.add(newDiv1);
        wrong++;
      }
      else{
        querySelector("#result_right$right").text=x["word"];
        DivElement toAdd=querySelector("#result_right$right");
        DivElement newDiv=new DivElement();
        int i=right+1;
        newDiv.setAttribute("id","result_right$i");
        toAdd.children.add(newDiv);
        right++;
      }
    }


  }}
///成绩界面的返回主页按钮：创建返回学生主页的路由
void result_return(MouseEvent event) {
  //todo 用户点击按钮返回主页的响应工作，返回到学生首页，并隐藏当前界面。
  var router = new Router(useFragment : true);
  router.root
    ..addRoute(name:'returnStuIndex',path:'',enter:returnStuIndex);//跳转到学生首页
  querySelector('#result_return').attributes['href']=router.url('returnStuIndex');
  router.listen();
}
///显示学生主页，隐藏成绩界面
void returnStuIndex(RouteEvent e) {
  document
      .querySelector('#student')
      .style
      .display = "block";
  document
      .querySelector('#result')
      .style
      .display = "none";
}


///教师部分

///显示教师主页
void TeaSignIn(RouteEvent e) {
  document
      .querySelector('#Teacher_Div')
      .style
      .display = "block";
  document
      .querySelector('#SignIn_Div_Form')
      .style
      .display = "none";
}

///布置任务

///教师首页的布置任务按钮：创建路由并发送获取数据的请求
void newTask(MouseEvent event) {
  var request = HttpRequest.getString("http://127.0.0.1:14080/teacherUnitWord").then(onTeaWord);
  var router = new Router(useFragment: true);
  router.root
    ..addRoute(
        name: 'newTask',
        path: '/tea/newTask',
        enter: teaNewTask);
  querySelector('#newTask').attributes['href'] =router.url('newTask');
  router.listen();
}
///布置任务界面：对获取到的单元的所有单词的数据进行处理显示
void onTeaWord (responseText) {
  var jsonString = responseText;
  wordlist = JSON.decode(jsonString);
  for ( tag = 1; tag < 21; tag++) {
    unitWord firstWord = new unitWord()
      ..Unit = wordlist[tag - 1]["Unit"]
      ..English = wordlist[tag - 1]["English"]
      ..Chinese = wordlist[tag - 1]["Chinese"];
    if (firstWord.Unit == 'unit1') {
      String showText = "英文：${firstWord.English} 中文：${firstWord.Chinese}";
      querySelector("#word$tag").nextNode.text = showText;
    }

  }

}
///跳转到布置任务的界面
void teaNewTask(RouteEvent e) {

  document
      .querySelector('#AssignWork_Div')
      .style
      .display = "block";
  document
      .querySelector('#Teacher_Div')
      .style
      .display = "none";


  //querySelector("#word1").text="hello";
}

///布置任务界面的确定按钮：对选择的单词进行处理，并创建跳转到确认已选择的单词的界面的路由
void SubmitWork(MouseEvent event) {
  //todo 记录用户选择的单词数据，存入Json文件
  //todo 隐藏当前界面，显示确认单词界面
  for(var i=1;i<21;i++)
  {unitWord wordString=new unitWord();
  wordString=wordlist[i-1];
  CheckboxInputElement wordTag=querySelector("#word$i");
  if(wordTag.checked && !(newWordList.contains(wordlist[i-1]))){
    newWordList.add(wordString);
  }
  }
  var router = new Router(useFragment: true);
  router.root
    ..addRoute(
        name: 'showWord',
        path: '/tea/showWord',
        enter:showWord);
  querySelector('#AssignWord_Btn').attributes['href'] =
      router.url('showWord');
  router.listen();
  TableElement table=querySelector("#choosenWord1");
  for(int num=1;num<=newWordList.length;num++)
  {
    querySelector("#choosenWord$num").text="中文："+newWordList[num-1]["Chinese"]+' '+"英文："+newWordList[num-1]["English"];

    var newTd=new TableRowElement();
    int i=num+1;
    newTd.setAttribute("id","choosenWord$i");
    table.children.add(newTd);

  }


}
///隐藏布置任务界面，显示展示教师已选择单词的界面，并且为确认和重新选择两个按钮定义事件
void showWord(RouteEvent e) {
  document
      .querySelector('#ConfirmWord_Div')
      .style
      .display = "block";
  document
      .querySelector('#AssignWork_Div')
      .style
      .display = "none";

  querySelector('#ConfirmWord_Reselect_Btn').onClick.listen(ReselectWord);
  querySelector('#ConfirmWord_Confirm_Btn')
    ..text = '确认'
    ..onClick.listen(ConfirmWord); //确认单词以及发布作业的按钮

}
/// 接受用户点击重新选择单词的按钮的响应，并创建相应路由
void ReselectWord(MouseEvent event) {
  //todo 删除原来存放在json文件中的临时单词数据，
  //todo 隐藏该界面，显示布置任务界面
  var router = new Router(useFragment: true);
  router.root
    ..addRoute(
        name: 'AnewTask',
        path: '/tea/newTask',
        enter:AnewTask);
  querySelector('#ConfirmWord_Reselect_Btn').attributes['href'] =
      router.url('AnewTask');
  router.listen();
  newWordList=[];//清空之前选择的单词
}
///显示布置任务界面
void AnewTask(RouteEvent e) {
  document
      .querySelector('#AssignWork_Div')
      .style
      .display = "block";
  document
      .querySelector('#ConfirmWord_Div')
      .style
      .display = "none";


}

/// 接受用户点击确认单词并发布作业的按钮的响应，并创建相应路由
void ConfirmWord(MouseEvent event) {
  //todo 将相应的json文件中的数据写入数据库
  //todo 显示提交单词成功界面
  var router = new Router(useFragment: true);
  router.root
    ..addRoute(
        name: 'SnewTask',
        path: '/tea/newTask/success',
        enter:SnewTask);
  querySelector('#ConfirmWord_Confirm_Btn').attributes['href'] =
      router.url('SnewTask');
  router.listen();
  String jsonData = encode(newWordList);
  HttpRequest request = new HttpRequest();
  request.onReadyStateChange.listen((_) {

  });
  var url = "http://127.0.0.1:14080/teacher_writetask";
  request.open("POST", url);
  request.send(jsonData);
}
///显示任务布置成功界面，隐藏其他界面
void SnewTask(RouteEvent e) {
  document
      .querySelector('#SucAssignWord_Div')
      .style
      .display = "block";
  document
      .querySelector('#ConfirmWord_Div')
      .style
      .display = "none";
  document
      .querySelector('#AssignWork_Div')
      .style
      .display = "none";
  querySelector('#SucAssignWord_Btn')
    ..text = '返回主界面'
    ..onClick.listen(ReturnTeacher); //返回教师主界面的按钮

}

/// 布置作业成功界面的返回主页按钮：创建路由，清空分配任务的单词列表
void ReturnTeacher(MouseEvent event) {
  //todo 隐藏当前界面，显示教师主界面
  var router = new Router(useFragment: true);
  router.root
    ..addRoute(
        name: 'returnTeacherIndex',
        path: '/tea/index',
        enter:returnTeacherIndex);
  querySelector('#SucAssignWord_Btn').attributes['href'] =
      router.url('returnTeacherIndex');
  router.listen();
  newWordList=[];//将之前选择的单词清空
}
///显示教师主页，隐藏作业布置成功界面
void returnTeacherIndex(RouteEvent e) {
  document.querySelector('#Teacher_Div').style.display = "block";
  document.querySelector('#SucAssignWord_Div').style.display = "none";
}


///查看任务完成情况

/// 教师主页选择查看任务情况的确定按钮：确定选择的任务，并创建路由
ftaskDiv(MouseEvent event) {
  //todo 根据在教师主界面中的任务情况的选择，从数据库中取出相应的学生数据并返回
  var object=document.getElementsByName("task");
  for(var index = 0;index < object.length;index++){
    if(object[index].checked){
      chosenTaskTeaView=object[index].value;
      break;
    }
  }
  var router = new Router(useFragment : true);
  router.root
    ..addRoute(name:'ftaskContent',path:'/teacher/viewtask',enter:ftaskContent);
  querySelector('#Ftask_Btn').attributes['href']=router.url('ftaskContent');
  router.listen();
}
///显示查看任务的完成情况的界面，并发送获取学生任务完成情况数据的请求
ftaskContent(RouteEvent e) async{
  document.querySelector('#Ftask_Div').style.display="block";
  document.querySelector('#Teacher_Div').style.display="none";
  var request =await HttpRequest.getString("http://127.0.0.1:14080/teacher_viewtask").then(
      stuScores);
}
///对获取到的学生任务完成情况的数据进行处理，显示
stuScores(responseText) {
  int stuNum=0;
  List listData = JSON.decode(responseText);
  //TableElement table=querySelector('#Ftask_table');
  TableRowElement row0=querySelector('#Ftask_Detail0');
  for(Map singleScore in listData) {
    StuScores firstStu = new StuScores()
      ..stuClass=singleScore["stuClass"]
      ..assignmentID=singleScore["assignmentID"]
      ..stuID=singleScore["stuID"]
      ..userName=singleScore["userName"]
      ..correctNum=singleScore["correctNum"]
      ..wrongNum=singleScore["wrongNum"];
    if((firstStu.stuClass == teacherClass)&&(firstStu.assignmentID ==chosenTaskTeaView) ){
      String showText="班级：${firstStu.stuClass} 学号：${firstStu.stuID} 姓名：${firstStu.userName} 正确个数：${firstStu.correctNum} 错误个数：${firstStu.wrongNum}";
      ///todo 动态创建表格里的行
      querySelector("#Ftask_Detail$stuNum").text=showText;
      var newTd=new TableRowElement();
      stuNum++;
      newTd.setAttribute("id","Ftask_Detail$stuNum");
      row0.children.add(newTd);
    }
  }
}
///查看任务完成情况界面的返回主页按钮：创建路由
void ReturnTeacher2(MouseEvent event) {
  //todo 隐藏当前界面，显示教师主界面
  var router = new Router(useFragment: true);
  router.root
    ..addRoute(
        name: 'returnTeacherIndex',
        path: '/tea/index',
        enter:returnTeacherIndex2);
  querySelector('#Teacher_Btn').attributes['href'] =
      router.url('returnTeacherIndex');
  router.listen();
}
///显示教师主页，隐藏查看任务完成情况界面
void returnTeacherIndex2(RouteEvent e) {
  document.querySelector('#Teacher_Div').style.display = "block";
  document.querySelector('#Ftask_Div').style.display = "none";
}




