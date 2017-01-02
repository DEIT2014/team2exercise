import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_route/shelf_route.dart';
import 'package:sqljocky/sqljocky.dart';
import 'dart:core';
import 'dart:io';
import 'dart:convert';
import 'package:jsonx/jsonx.dart';
import 'package:team2exercise/stuscores.dart';
import "package:team2exercise/teacherWord.dart";
String responseText;//注册时返回到客户端的数据：写入数据库成功，返回0；失败，返回错误值，不为0
final _headers={"Access-Control-Allow-Origin":"*",
  "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
  "Access-Control-Allow-Headers":"Origin, X-Requested-With, Content-Type, Accept",
  "Content-Type":"application/json"};

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
    ..get('/teacherUnitWord',responseWord)//获取单元单词
  //post
    ..post('/student_signup',responseStuSignUp)
    ..post('/teacher_signup',responseTeaSignUp)
    ..post('/teacher_writetask',responseTeaWriteTask)//传递教师提交任务的数据
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
  var data=await pool.query('select UserID,Username,Password,Class,Status from userinfo');
  //下面这个语句比较慢，一定要等它
  await data.forEach((row){
    singledata={'"UserID"':'"${row.UserID}"','"Username"':'"${row.Username}"','"Password"':'"${row.Password}"','"Class"':'"${row.Class}"','"Status"':'"${row.Status}"'};//按照这个格式存放单条数据
    userdata.add(singledata);//将该数据加入数组中
  });
  //将用户数据存入数组中
  finaluserdata={'"Userinfo"':userdata};
  return (new Response.ok(finaluserdata.toString(),headers: _headers));
}

///获取学生完成情况数据
responseTeaViewTask(request)async{
  //todo 访问数据库，从testscore表中获取相关数据（姓名、正确几个、错误几个）
  List stuScores = new List();
  var pool = new ConnectionPool(host:'localhost',port:3306,user:'root',db:'vocabulary',max:5);
  var data = await pool.query('select testscore.Class,testscore.userID,assignmentID,correctNum,wrongNum,Username '
      'from testscore,userinfo where testscore.userID=userinfo.userID order by userID ASC');
  await data.forEach((row){
    StuScores stuScore = new StuScores()
      ..stuClass = row.Class
      ..assignmentID = row.assignmentID
      ..stuID = row.userID
      ..userName=row.Username
      ..correctNum = row.correctNum
      ..wrongNum = row.wrongNum;
    stuScores.add(stuScore);
  });
  print('success!');
  String jsonData = encode(stuScores);
  return (new Response.ok(jsonData,headers: _headers));
}
//获取单元单词
responseWord(request)async{
  //todo 访问数据库，从单词表中获取一个单元的单词
  var wordList=[];
  var pool=new ConnectionPool(host:'localhost',port:3306,user:'root',db:'vocabulary',max:5);
  var data=await pool.query('select Unit,word,Chinese from wordlist');
  await data.forEach((row)
  {
    unitWord word=new unitWord();
    word.Unit="${row.Unit}";
    word.English="${row.word}";
    word.Chinese="${row.Chinese}";
    print(word.English);
    wordList.add(word);//将数据添加到list中

  });
  String wordListJson=encode(wordList);
  List<unitWord> word = decode(wordListJson,type:const TypeHelper<List<unitWord>>().type);
  unitWord word1 = new unitWord();
  word1 = word[0];
  print(word1.English);
  return (new Response.ok('${wordListJson}',headers: _headers));

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
  //todo 学生注册
  /**有问题的
      var responseDBText=await request.readAsString().then(insertDataBaseStu);//then返回的到底是什么，怎么样获取insertDataBaseStu的返回值，_Future类的值怎么取？
      String realText=responseDBText.toString();
      print(realText);
      return (new Response.ok('success!',headers: _headers));
   **/
  await request.readAsString().then(insertDataBaseStu);
  //todo 写入数据库成功则responseText值为‘0’，否则是‘$error’（错误的内容）
  if(responseText == '0'){
    return (new Response.ok('success',headers: _headers));
  }
  else{
    return (new Response.ok('failure',headers: _headers));
  }

}
///对读取到的客户端学生注册的信息进行处理
insertDataBaseStu(data) async{
  String username;
  String userClass;
  String password;
  String userID;
  Map realdata=JSON.decode(data);
  username=realdata['Username'];
  userClass=realdata['Class'];
  password=realdata['Password'];
  userID=realdata['UserID'];
  //todo 将数据存入数据库
  var pool=new ConnectionPool(host:'localhost',port:3306,user:'root',db:'vocabulary',max:5);
  var query=await pool.prepare('insert into userinfo(UserID,Username,Password,Class,Status) values(?,?,?,?,?)');
  await query.execute([userID,username,password,userClass,'stu']).then((result){
    print('${result.insertId}');//如果插入成功，这会是0，否则会报错
    responseText='${result.insertId}';
  }).catchError((error){
    //todo 出错的情况下，返回错误的内容
    print('$error');
    responseText=error.toString();
  });
}

responseTeaSignUp(request) async{
  //todo 将教师的注册信息写入数据库
  await request.readAsString().then(insertDataBaseTea);
  //todo 写入数据库成功则responseText值为‘0’，否则是‘$error’（错误的内容）
  if(responseText == '0'){
    return (new Response.ok('success',headers: _headers));
  }
  else{
    return (new Response.ok('failure',headers: _headers));
  }
}

insertDataBaseTea(data) async{
  String username;
  String userClass;
  String password;
  String userID;
  Map realdata=JSON.decode(data);
  username=realdata['Username'];
  userClass=realdata['Class'];
  password=realdata['Password'];
  userID=realdata['UserID'];
  //todo 将数据存入数据库
  var pool=new ConnectionPool(host:'localhost',port:3306,user:'root',db:'vocabulary',max:5);
  var query=await pool.prepare('insert into userinfo(UserID,Username,Password,Class,Status) values(?,?,?,?,?)');
  await query.execute([userID,username,password,userClass,'tea']).then((result){
    print('${result.insertId}');//如果插入成功，这会是0，否则会报错
    responseText='${result.insertId}';
  }).catchError((error){
    //todo 出错的情况下，返回错误的内容
    print('$error');
    responseText=error.toString();
  });
}


///将教师的布置任务数据写入数据库
responseTeaWriteTask(request) async{
  //todo 将老师布置的任务数据写入数据库的任务表中
  await request.readAsString().then(insertDataBaseTask);
  return (new Response.ok('',headers: _headers));

}

insertDataBaseTask(data) async{
  var taskWord=JSON.decode(data);
  var myDate=new DateTime.now();
  for(int i=0;i<taskWord.length;i++)
  {
    String English;
    English=taskWord[i]['English'];
    //todo 将数据存入数据库
    var pool=new ConnectionPool(host:'localhost',port:3306,user:'root',db:'vocabulary',max:5);
    var query=await pool.prepare('insert into assignmentcontent(assignmentID,word) values(?,?)');
    await query.execute([myDate,English]).then((result){
      print('${result.insertId}');//如果插入成功，这会是0，否则会报错
      responseText='${result.insertId}';
    }).catchError((error){
      //todo 出错的情况下，返回错误的内容
      print('$error');
      responseText=error.toString();
    });
  }

  var pool=new ConnectionPool(host:'localhost',port:3306,user:'root',db:'vocabulary',max:5);
  var query=await pool.prepare('insert into assignment(assignmentID,Class,assignmentNum) values(?,?,?)');
  await query.execute([myDate,'class1',taskWord.length]).then((result){
    print('${result.insertId}');//如果插入成功，这会是0，否则会报错
    responseText='${result.insertId}';
  }).catchError((error){
    //todo 出错的情况下，返回错误的内容
    print('$error');
    responseText=error.toString();
  });
}
///并将学生听写单词的中文以及英文写入到一个JSON文件中，并上传给数据库
responseStuTest(request){
  //todo 将将学生听写单词的中文以及英文写入到一个JSON文件中，并判断正误，以及上传给数据库
}