import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_route/shelf_route.dart';

void main() {
  var myRouter = router()
  //get
    ..get('/userinfo',responseUser)
    ..get('/teacher_viewtask',responseTeaViewTask)
    ..get('/teacher_gettask',responseTeaGetTask)
    ..get('/student/index', responseStu)
    ..get('/finished',responseFinished)
    ..get('/review', responseReview)
    ..get('/test',responseTest)
    ..get('/result',responseResult)
  //post
    ..post('/teacher_writetask',responseTeaWriteTask)
    ..post('/student_test',responseStuTest);

  io.serve(myRouter.handler, '127.0.0.1', 14080);
}
///获取用户的信息（登录时）
responseUser(request){
  //todo 访问数据库，从用户信息表中获取并返回用户登录的信息，包括用户名、密码和身份属性
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
  return new Response.ok("学生待完成任务");//可以返回数据库中的数据，修改“”
}

///获取登录学生已完成任务信息
responseFinished(request)
{//todo 访问数据库，获取登录学生的已完成任务信息，包括任务名称，以及每个单词的完成正误情况
  return new Response.ok("已完成任务 ");//可以返回数据库中的数据，修改“”
}

///获取学生选择任务的所有单词信息，包括总共的单词英文、中文、发音
responseReview(request)
{//TODO 访问数据库，获取任务中的单词，并转换为JSON
  return new Response.ok("Word");//可以返回数据库中的数据，修改“”
}

///获取学生所选择任务的所有单词信息，包括总共的单词英文、中文、发音，以及两个不正确的中文意思
responseTest(request)
{//todo 访问数据库，获取登录学生选择测试任务的数据，并转换为JSON
  return new Response.ok("Test");//可以返回数据库中的数据，修改“”
}
///获取学生该次听写任务的正确或者错误结果数据
responseResult(request)
{//todo 访问数据库，获取登录学生本次测试任务结果的数据，并转换为JSON
  return new Response.ok("Result");//可以返回数据库中的数据，修改“”
}

///将教师的布置任务数据写入数据库
responseTeaWriteTask(request){
  //todo 将老师布置的任务数据写入数据库的任务表中
}

///并将学生听写单词的中文以及英文写入到一个JSON文件中，并上传给数据库
responseStuTest(request){
  //todo 将将学生听写单词的中文以及英文写入到一个JSON文件中，并判断正误，以及上传给数据库
}