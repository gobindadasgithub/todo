import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list_app/Constant/constant.dart';
import 'package:todo_list_app/HomePage/homePage.dart';
import 'package:todo_list_app/OnboardingPage/OnBoardModel.dart';

class OnBoard extends StatefulWidget {
  const OnBoard({Key? key}) : super(key: key);

  @override
  State<OnBoard> createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {

  int currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }


  _storeOnboardInfo() async {

    print("Shared pref called");
    int isViewed = 0;
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    await sharedPreferences.setInt('OnBoard', isViewed);
    print(sharedPreferences.getInt('onBoard'));

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: currentIndex % 2 == 0 ? kwhite:kblue,
      appBar: AppBar(
        backgroundColor: currentIndex % 2 == 0 ? kwhite : kblue,
        elevation: 0.0,
        actions: [
          TextButton(
            onPressed: () {
              _storeOnboardInfo();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => const HomePage()));
            },
            child: Text(
              "Skip",
              style: TextStyle(
                color: currentIndex % 2 == 0 ? kblack : kwhite,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: PageView.builder(
          itemCount: screens.length,
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (int index){
            setState(() {
              currentIndex=index;
            });
            },
            itemBuilder: (_,index){
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(screens[index].img),
                Container(
                  height: 10.0,
                  child: ListView.builder(
                    itemCount: screens.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,

                      itemBuilder: (context,index){
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3.0),
                            width: currentIndex == index ? 25 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: currentIndex == index
                                  ? kbrown
                                  : kbrown300,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ],

                      );

                      }),
                ),

                Text(
                  screens[index].text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 27.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: index % 2 == 0 ? kblack : kwhite,
                  ),
                ),
                Text(
                  screens[index].desc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontFamily: 'Montserrat',
                    color: index % 2 == 0 ? kblack : kwhite,
                  ),
                ),
                InkWell(
                  onTap: () async {
                    print(index);
                    if (index == screens.length - 1) {
                      await _storeOnboardInfo();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    }

                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.bounceIn,
                    );
                  },
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                    decoration: BoxDecoration(
                        color: index % 2 == 0 ? kblue : kwhite,
                        borderRadius: BorderRadius.circular(15.0)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Text(
                        "Next",
                        style: TextStyle(
                            fontSize: 16.0,
                            color: index % 2 == 0 ? kwhite : kblue),
                      ),
                      const SizedBox(
                        width: 15.0,
                      ),
                      Icon(
                        Icons.arrow_forward_sharp,
                        color: index % 2 == 0 ? kwhite : kblue,
                      )
                    ]),
                  ),
                )

              ],
            );

            }),
      ),

    );
  }
}
