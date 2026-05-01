// class CardSlider extends StatelessWidget {
//   final Function(int) onPageChanged;
//
//   const CardSlider({super.key, required this.onPageChanged});
//
//   final PageController _controller = PageController(viewportFraction: 0.8);
//   double currentPage = 0;

// @override
// void initState() {
//   super.initState();
//
//   _controller.addListener(() {
//     setState(() {
//       currentPage = _controller.page!;
//     });
//   });
// }

// @override
// Widget build(BuildContext context) {
//   return PageView.builder(
//     itemCount: 5,
//     onPageChanged: onPageChanged, // 🔥 important
//     // itemBuilder: (context, index) {
//     //   return CreditCardWidget(index);
//     // },
//   );
// return AnimatedSwitcher(
//   duration: Duration(milliseconds: 300),
//   child: SizedBox(
//     height: 220,
//     child: PageView.builder(
//       // physics: BouncingScrollPhysics(),
//       controller: _controller,
//       itemCount: 5,
//       itemBuilder: (context, index) {
//         double diff = index - currentPage;
//         // double scale = (1 - (diff.abs() * 0.2)).clamp(0.8, 1.0);
//         // double translateY = (1 - scale) * 50;
//
//         return Transform(
//           transform: Matrix4.identity(),
//           child: _buildCard(index),
//         );
//       },
//     ),
//   ),
// );
// }

//   Widget _buildCard(int index) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         gradient: LinearGradient(
//           colors: [Colors.orange, Colors.red],
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black26,
//             blurRadius: 10,
//             offset: Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Center(
//         child: Text(
//           "Card $index",
//           style: TextStyle(color: Colors.white, fontSize: 20),
//         ),
//       ),
//     );
//   }
// }
