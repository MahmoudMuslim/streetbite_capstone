import 'package:flutter/material.dart';
class Orders extends StatefulWidget {
	const Orders({super.key});
	@override
	OrdersState createState() => OrdersState();
}
class OrdersState extends State<Orders> {
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: SafeArea(
				child: Container(
					constraints: const BoxConstraints.expand(),
					color: Color(0xFFFFFFFF),
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							Expanded(
								child: IntrinsicHeight(
									child: Container(
										color: Color(0xFFFFFFFF),
										width: double.infinity,
										height: double.infinity,
										child: SingleChildScrollView(
											child: Column(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: [
													IntrinsicHeight(
														child: Container(
															color: Color(0xFFFFFFFF),
															width: double.infinity,
															child: Row(
																mainAxisAlignment: MainAxisAlignment.spaceBetween,
																children: [
																	Container(
																		margin: const EdgeInsets.only( left: 47),
																		child: Text(
																			"9:41",
																			style: TextStyle(
																				color: Color(0xFF1C1B1F),
																				fontSize: 17,
																				fontWeight: FontWeight.bold,
																			),
																		),
																	),
																	Container(
																		width: 134,
																		height: 54,
																		child: Image.network(
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/5olgbr8v_expires_30_days.png",
																			fit: BoxFit.fill,
																		)
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															color: Color(0xFFFFFFFF),
															padding: const EdgeInsets.only( top: 44, left: 20),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	Container(
																		margin: const EdgeInsets.only( bottom: 16),
																		child: Text(
																			"Orders",
																			style: TextStyle(
																				color: Color(0xFF1C1B1F),
																				fontSize: 36,
																				fontWeight: FontWeight.bold,
																			),
																		),
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															padding: const EdgeInsets.only( top: 8, bottom: 8, left: 20, right: 20),
															width: double.infinity,
															child: Row(
																children: [
																	Container(
																		decoration: BoxDecoration(
																			borderRadius: BorderRadius.circular(16),
																		),
																		margin: const EdgeInsets.only( right: 16),
																		width: 96,
																		height: 88,
																		child: ClipRRect(
																			borderRadius: BorderRadius.circular(16),
																			child: Image.network(
																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/iv95c0gv_expires_30_days.png",
																				fit: BoxFit.fill,
																			)
																		)
																	),
																	Expanded(
																		child: IntrinsicHeight(
																			child: Container(
																				padding: const EdgeInsets.only( right: 46),
																				width: double.infinity,
																				child: Column(
																					crossAxisAlignment: CrossAxisAlignment.start,
																					children: [
																						IntrinsicWidth(
																							child: IntrinsicHeight(
																								child: Container(
																									width: double.infinity,
																									child: Row(
																										children: [
																											Container(
																												decoration: BoxDecoration(
																													border: Border.all(
																														color: Color(0xFF00C773),
																														width: 3,
																													),
																													borderRadius: BorderRadius.circular(16),
																												),
																												margin: const EdgeInsets.only( right: 4),
																												width: 12,
																												height: 12,
																												child: SizedBox(),
																											),
																											Text(
																												"Arrives in 25-30 min",
																												style: TextStyle(
																													color: Color(0xFF00C773),
																													fontSize: 20,
																													fontWeight: FontWeight.bold,
																												),
																											),
																										]
																									),
																								),
																							),
																						),
																						Text(
																							"Sabor Mexicano Grill",
																							style: TextStyle(
																								color: Color(0xFF1C1B1F),
																								fontSize: 16,
																								fontWeight: FontWeight.bold,
																							),
																						),
																					]
																				),
																			),
																		),
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															color: Color(0xFFFFFFFF),
															padding: const EdgeInsets.only( top: 28, left: 20),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	Container(
																		margin: const EdgeInsets.only( bottom: 5),
																		child: Text(
																			"Past",
																			style: TextStyle(
																				color: Color(0xFF1C1B1F),
																				fontSize: 28,
																				fontWeight: FontWeight.bold,
																			),
																		),
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															padding: const EdgeInsets.only( top: 12, bottom: 12, left: 20, right: 20),
															width: double.infinity,
															child: Row(
																children: [
																	Container(
																		decoration: BoxDecoration(
																			borderRadius: BorderRadius.circular(16),
																		),
																		margin: const EdgeInsets.only( right: 16),
																		width: 96,
																		height: 88,
																		child: ClipRRect(
																			borderRadius: BorderRadius.circular(16),
																			child: Image.network(
																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/czfmy2qe_expires_30_days.png",
																				fit: BoxFit.fill,
																			)
																		)
																	),
																	Expanded(
																		child: IntrinsicHeight(
																			child: Container(
																				width: double.infinity,
																				child: Column(
																					crossAxisAlignment: CrossAxisAlignment.start,
																					children: [
																						Container(
																							margin: const EdgeInsets.only( bottom: 4),
																							child: Text(
																								"Sunrise Eats",
																								style: TextStyle(
																									color: Color(0xFF1C1B1F),
																									fontSize: 16,
																									fontWeight: FontWeight.bold,
																								),
																							),
																						),
																						IntrinsicWidth(
																							child: IntrinsicHeight(
																								child: Row(
																									children: [
																										Container(
																											margin: const EdgeInsets.only( right: 8),
																											child: Text(
																												"2 items",
																												style: TextStyle(
																													color: Color(0xFFA09CAB),
																													fontSize: 14,
																												),
																											),
																										),
																										Container(
																											decoration: BoxDecoration(
																												borderRadius: BorderRadius.circular(2),
																												color: Color(0xFFDADDE3),
																											),
																											margin: const EdgeInsets.only( right: 6),
																											width: 3,
																											height: 3,
																											child: SizedBox(),
																										),
																										Text(
																											"Today",
																											style: TextStyle(
																												color: Color(0xFFA09CAB),
																												fontSize: 14,
																											),
																										),
																									]
																								),
																							),
																						),
																					]
																				),
																			),
																		),
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															padding: const EdgeInsets.only( top: 12, bottom: 12, left: 20, right: 20),
															margin: const EdgeInsets.only( bottom: 184),
															width: double.infinity,
															child: Row(
																children: [
																	Container(
																		decoration: BoxDecoration(
																			borderRadius: BorderRadius.circular(16),
																		),
																		margin: const EdgeInsets.only( right: 16),
																		width: 96,
																		height: 88,
																		child: ClipRRect(
																			borderRadius: BorderRadius.circular(16),
																			child: Image.network(
																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/wow2l2g2_expires_30_days.png",
																				fit: BoxFit.fill,
																			)
																		)
																	),
																	Expanded(
																		child: IntrinsicHeight(
																			child: Container(
																				width: double.infinity,
																				child: Column(
																					crossAxisAlignment: CrossAxisAlignment.start,
																					children: [
																						Container(
																							margin: const EdgeInsets.only( bottom: 4),
																							child: Text(
																								"Burger Haven",
																								style: TextStyle(
																									color: Color(0xFF1C1B1F),
																									fontSize: 16,
																									fontWeight: FontWeight.bold,
																								),
																							),
																						),
																						IntrinsicWidth(
																							child: IntrinsicHeight(
																								child: Row(
																									children: [
																										Container(
																											margin: const EdgeInsets.only( right: 8),
																											child: Text(
																												"6 items",
																												style: TextStyle(
																													color: Color(0xFFA09CAB),
																													fontSize: 14,
																												),
																											),
																										),
																										Container(
																											decoration: BoxDecoration(
																												borderRadius: BorderRadius.circular(2),
																												color: Color(0xFFDADDE3),
																											),
																											margin: const EdgeInsets.only( right: 6),
																											width: 3,
																											height: 3,
																											child: SizedBox(),
																										),
																										Text(
																											"6 days ago",
																											style: TextStyle(
																												color: Color(0xFFA09CAB),
																												fontSize: 14,
																											),
																										),
																									]
																								),
																							),
																						),
																					]
																				),
																			),
																		),
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															color: Color(0xFFFFFFFF),
															padding: const EdgeInsets.only( top: 10, bottom: 10, left: 36, right: 36),
															width: double.infinity,
															child: Row(
																children: [
																	Expanded(
																		child: IntrinsicHeight(
																			child: Container(
																				margin: const EdgeInsets.only( right: 37),
																				width: double.infinity,
																				child: Column(
																					children: [
																						Container(
																							margin: const EdgeInsets.only( bottom: 3),
																							width: 24,
																							height: 24,
																							child: Image.network(
																								"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/z16ibo5w_expires_30_days.png",
																								fit: BoxFit.fill,
																							)
																						),
																						Text(
																							"Home",
																							style: TextStyle(
																								color: Color(0xFFA09CAB),
																								fontSize: 11,
																							),
																						),
																					]
																				),
																			),
																		),
																	),
																	Expanded(
																		child: IntrinsicHeight(
																			child: Container(
																				margin: const EdgeInsets.only( right: 37),
																				width: double.infinity,
																				child: Column(
																					children: [
																						Container(
																							margin: const EdgeInsets.only( bottom: 3),
																							width: 24,
																							height: 24,
																							child: Image.network(
																								"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/60x1i6rv_expires_30_days.png",
																								fit: BoxFit.fill,
																							)
																						),
																						Text(
																							"Browse",
																							style: TextStyle(
																								color: Color(0xFFA09CAB),
																								fontSize: 11,
																							),
																						),
																					]
																				),
																			),
																		),
																	),
																	Expanded(
																		child: IntrinsicHeight(
																			child: Container(
																				margin: const EdgeInsets.only( right: 37),
																				width: double.infinity,
																				child: Column(
																					children: [
																						Container(
																							margin: const EdgeInsets.only( bottom: 3),
																							width: 24,
																							height: 24,
																							child: Image.network(
																								"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/41ufc72e_expires_30_days.png",
																								fit: BoxFit.fill,
																							)
																						),
																						Text(
																							"Orders",
																							style: TextStyle(
																								color: Color(0xFF00C773),
																								fontSize: 11,
																							),
																						),
																					]
																				),
																			),
																		),
																	),
																	Expanded(
																		child: IntrinsicHeight(
																			child: Container(
																				width: double.infinity,
																				child: Column(
																					children: [
																						Container(
																							margin: const EdgeInsets.only( bottom: 3),
																							width: 24,
																							height: 24,
																							child: Image.network(
																								"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/eehbc82l_expires_30_days.png",
																								fit: BoxFit.fill,
																							)
																						),
																						Text(
																							"Profile",
																							style: TextStyle(
																								color: Color(0xFFA09CAB),
																								fontSize: 11,
																							),
																						),
																					]
																				),
																			),
																		),
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															color: Color(0xFFFFFFFF),
															padding: const EdgeInsets.symmetric(vertical: 8),
															width: double.infinity,
															child: Column(
																children: [
																	Container(
																		decoration: BoxDecoration(
																			borderRadius: BorderRadius.circular(100),
																			color: Color(0xFF1C1B1F),
																		),
																		width: 139,
																		height: 5,
																		child: SizedBox(),
																	),
																]
															),
														),
													),
												],
											)
										),
									),
								),
							),
						],
					),
				),
			),
		);
	}
}