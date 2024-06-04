
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PopUpMsg extends StatefulWidget {
  const PopUpMsg({super.key});

  @override
  State<PopUpMsg> createState() => _PopUpMsgState();
}

class _PopUpMsgState extends State<PopUpMsg> {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.7),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              height: mediaQuery.size.height * 0.4,
              width: mediaQuery.size.width * 0.9,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(11)),
              child: Column(
                children: [
                  Container(
                    height: mediaQuery.size.height * 0.1,
                    width: mediaQuery.size.width * 1,
                    decoration: BoxDecoration(
                        color: Colors.pink,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(11),
                          topRight: Radius.circular(11),
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 2,
                            spreadRadius: 2,
                            color: Colors.grey,
                            offset: Offset(2, 2),
                          )
                        ]
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(child: Text("Mon , 14 Aug 2024",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w800),))
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.only(top: 15,),
                    child: Container(
                      height: mediaQuery.size.height * 0.06,
                      width: mediaQuery.size.width * 1,
                      decoration: BoxDecoration(color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 2,
                              spreadRadius: 2,
                              color: Colors.grey,
                              offset: Offset(2, 2),
                            )
                          ]
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Type",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 18),),
                          Text("Clock In",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 18),),
                          Text("Clock Out",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 18),),
                          Text("Duration",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 18),),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Container(
                            margin: EdgeInsets.zero,
                            height: mediaQuery.size.height * 0.06,
                            width: mediaQuery.size.width * 0.95,
                            decoration: BoxDecoration(color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 2,
                                    spreadRadius: 2,
                                    color: Colors.grey,
                                    offset: Offset(2, 2),
                                  )
                                ]
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("Work",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600),),
                                Text("8 AM",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600),),
                                Text("7 AM",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600),),
                                Text("10 Hour",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600),),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}