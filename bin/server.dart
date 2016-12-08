import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_route/shelf_route.dart';
import 'package:sqljocky/sqljocky.dart';
import 'dart:core';
import 'dart:io';
import 'dart:convert';

final _headers={"Access-Control-Allow-Origin":"*",
  "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
  "Access-Control-Allow-Headers":"Origin, X-Requested-With, Content-Type, Accept"};

void main() {
  var myRouter = router()
  //get
    ..get('/userinfo',responseUser)
    ..get('/teacher_viewtask',responseTeaViewTask)
    ..get('/teacher_gettask',responseTeaGetTask)
    ..get('/student/index', responseStu)
    ..get('/finished',responseFinished)
    ..get('/review', responseReview)
    ..get('/test/get',responseTest)
    ..get('/result',responseResult)
  //post
    ..post('/student_signup',responseStuSignUp)
    ..post('/teacher_signup',responseTeaSignUp)
    ..post('/teacher_writetask',responseTeaWriteTask)
    ..post('/student_test/post',responseStuTest);

  io.serve(myRouter.handler, '127.0.0.1', 14080);
}
///获取数据库中所有用户的信息（登录时）
responseUser(request)async{
  //todo 访问数据库，从用户信息表中获取并返回用户登录的信息，包括用户名、密码和身份属性
  var singledata=new Map<String,String>();//存放单个用户数据
  var userdata=new List();//存放所有用户的数据
  var finaluserdata=new Map<String,String>();//存放最终的用户数据
  var pool=new ConnectionPool(host:'localhost',port:3306,user:'root',db:'vocabulary',max:5);
  var data=await pool.query('select Username,Password,Class,Status from userinfo');
  //下面这个语句比较慢，一定要等它
  await data.forEach((row){
    singledata={'"Username"':'"${row.Username}"','"Password"':'"${row.Password}"','"Class"':'"${row.Class}"','"Status"':'"${row.Status}"'};//按照这个格式存放单条数据
    userdata.add(singledata);//将该数据加入数组中
  });
  //将用户数据存入数组中
  finaluserdata={'"Userinfo"':userdata};
  return (new Response.ok(finaluserdata.toString(),headers: _headers));
}

///获取学生完成情况数据
responseTeaViewTask(request){
  //todo 访问数据库，从学生任务完成情况表2中获取相关数据（第几课时、日期、各个学生的成绩）
}

///获取教师布置任务的数据
responseTeaGetTask(request){
  //todo 访问数据库，从任务表中取出任务数据（包括第几课时、日期、单词等）
}

///获取登录学生班级姓名信息，并根据班级获得数据中学生待完成任务信息
responseStu(request)
{//todo 访问数据库，获取登录学生的待完成任务数据，并转换为json
  //return new Response.ok("学生待完成任务");//可以返回数据库中的数据，修改“”
}

///获取登录学生已完成任务信息
responseFinished(request)
{//todo 访问数据库，获取登录学生的已完成任务信息，包括任务名称，以及每个单词的完成正误情况
  //return new Response.ok("已完成任务 ");//可以返回数据库中的数据，修改“”
}

///获取学生选择任务的所有单词信息，包括总共的单词英文、中文、发音
responseReview(request)
{//todo 访问数据库，获取任务中的单词，并转换为JSON
  // return new Response.ok("Word");//可以返回数据库中的数据，修改“”
}

///获取学生所选择任务的所有单词信息，包括总共的单词英文、中文、发音，以及两个不正确的中文意思
responseTest(request)
{//todo 访问数据库，获取登录学生选择测试任务的数据，并转换为JSON
  // return new Response.ok("Test");//可以返回数据库中的数据，修改“”
}
///获取学生该次听写任务的正确或者错误结果数据
responseResult(request)
{//todo 访问数据库，从已完成任务表中获取登录学生本次测试任务结果的数据，并转换为JSON
  // return new Response.ok("Result");//可以返回数据库中的数据，修改“”
}

///
responseStuSignUp(request) async{
  //todo
  request.readAsString().then(insertDataBaseStu);
  //
  return (new Response.ok('success!',headers: _headers));
}
insertDataBaseStu(data) async{
  String username;
  String userClass;
  String password;
  Map realdata=JSON.decode(data);
  username=realdata['Username'];
  userClass=realdata['Class'];
  password=realdata['Password'];
  //todo 将数据存入数据库
  var pool=new ConnectionPool(host:'localhost',port:3306,user:'root',db:'vocabulary',max:5);
  var query=await pool.prepare('insert into userinfo(Username,Password,Class,Status) values(?,?,?,?)');
  var result=await query.execute([username,userClass,password,'stu']);
}

responseTeaSignUp(request) async{
  //todo 将教师的注册信息写入数据库
  request.readAsString().then(insertDataBaseTea);
  //
  return (new Response.ok('success!',headers: _headers));
}

insertDataBaseTea(data) async{
  String username;
  String userClass;
  String password;
  Map realdata=JSON.decode(data);
  username=realdata['Username'];
  userClass=realdata['Class'];
  password=realdata['Password'];
  //todo 将数据存入数据库
  var pool=new ConnectionPool(host:'localhost',port:3306,user:'root',db:'vocabulary',max:5);
  var query=await pool.prepare('insert into userinfo(Username,Password,Class,Status) values(?,?,?,?)');
  var result=await query.execute([username,userClass,password,'tea']);
}


///将教师的布置任务数据写入数据库
responseTeaWriteTask(request){
  //todo 将老师布置的任务数据写入数据库的任务表中
}

///并将学生听写单词的中文以及英文写入到一个JSON文件中，并上传给数据库
responseStuTest(request){
  //todo 将将学生听写单词的中文以及英文写入到一个JSON文件中，并判断正误，以及上传给数据库
}