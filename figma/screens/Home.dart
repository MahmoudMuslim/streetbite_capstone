import 'package:flutter/material.dart';
class Home extends StatefulWidget {
	const Home({super.key});
	@override
	HomeState createState() => HomeState();
}
class HomeState extends State<Home> {
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
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/ux00nxcq_expires_30_days.png",
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
															padding: const EdgeInsets.only( top: 12, bottom: 12, left: 20, right: 20),
															width: double.infinity,
															child: Row(
																children: [
																	Container(
																		margin: const EdgeInsets.only( right: 4),
																		width: 24,
																		height: 24,
																		child: Image.network(
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/qx5amzrf_expires_30_days.png",
																			fit: BoxFit.fill,
																		)
																	),
																	Text(
																		"Park Way 145",
																		style: TextStyle(
																			color: Color(0xFF00C773),
																			fontSize: 20,
																			fontWeight: FontWeight.bold,
																		),
																	),
																	Expanded(
																		child: Container(
																			width: double.infinity,
																			child: SizedBox(),
																		),
																	),
																	Container(
																		width: 54,
																		height: 24,
																		child: Image.network(
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/9ocy6ca1_expires_30_days.png",
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
															padding: const EdgeInsets.only( top: 8, bottom: 8, left: 20, right: 20),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	IntrinsicHeight(
																		child: Container(
																			decoration: BoxDecoration(
																				borderRadius: BorderRadius.circular(32),
																				color: Color(0xFFF7F7F7),
																			),
																			padding: const EdgeInsets.only( top: 10, bottom: 10, left: 16, right: 16),
																			width: double.infinity,
																			child: Row(
																				mainAxisAlignment: MainAxisAlignment.spaceBetween,
																				children: [
																					Container(
																						decoration: BoxDecoration(
																							borderRadius: BorderRadius.circular(32),
																						),
																						width: 24,
																						height: 24,
																						child: ClipRRect(
																							borderRadius: BorderRadius.circular(32),
																							child: Image.network(
																								"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/awaby5nh_expires_30_days.png",
																								fit: BoxFit.fill,
																							)
																						)
																					),
																					Text(
																						"Food, groceries, etc.",
																						style: TextStyle(
																							color: Color(0xFFA09CAB),
																							fontSize: 16,
																						),
																					),
																					Container(
																						width: 24,
																						height: 24,
																						child: SizedBox(),
																					),
																				]
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
															width: double.infinity,
															child: SingleChildScrollView(
																scrollDirection: Axis.horizontal,
																child: Row(
																	crossAxisAlignment: CrossAxisAlignment.start,
																	children: [
																		IntrinsicWidth(
																			child: IntrinsicHeight(
																				child: Container(
																					padding: const EdgeInsets.only( left: 7, right: 7),
																					margin: const EdgeInsets.only( right: 4),
																					child: Column(
																						crossAxisAlignment: CrossAxisAlignment.start,
																						children: [
																							Container(
																								decoration: BoxDecoration(
																									borderRadius: BorderRadius.circular(32),
																								),
																								margin: const EdgeInsets.only( bottom: 8),
																								width: 64,
																								height: 64,
																								child: ClipRRect(
																									borderRadius: BorderRadius.circular(32),
																									child: Image.network(
																										"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/e9taikq6_expires_30_days.png",
																										fit: BoxFit.fill,
																									)
																								)
																							),
																							Text(
																								"Acclaimed",
																								style: TextStyle(
																									color: Color(0xFF1C1B1F),
																									fontSize: 13,
																									fontWeight: FontWeight.bold,
																								),
																							),
																						]
																					),
																				),
																			),
																		),
																		IntrinsicWidth(
																			child: IntrinsicHeight(
																				child: Container(
																					padding: const EdgeInsets.only( left: 7, right: 7),
																					margin: const EdgeInsets.only( right: 4),
																					child: Column(
																						children: [
																							Container(
																								decoration: BoxDecoration(
																									borderRadius: BorderRadius.circular(32),
																								),
																								margin: const EdgeInsets.only( bottom: 8),
																								width: 64,
																								height: 64,
																								child: ClipRRect(
																									borderRadius: BorderRadius.circular(32),
																									child: Image.network(
																										"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/kupdjz1j_expires_30_days.png",
																										fit: BoxFit.fill,
																									)
																								)
																							),
																							Text(
																								"Healthy",
																								style: TextStyle(
																									color: Color(0xFF1C1B1F),
																									fontSize: 13,
																									fontWeight: FontWeight.bold,
																								),
																							),
																						]
																					),
																				),
																			),
																		),
																		IntrinsicWidth(
																			child: IntrinsicHeight(
																				child: Container(
																					padding: const EdgeInsets.only( left: 7, right: 7),
																					margin: const EdgeInsets.only( right: 4),
																					child: Column(
																						children: [
																							Container(
																								decoration: BoxDecoration(
																									borderRadius: BorderRadius.circular(32),
																								),
																								margin: const EdgeInsets.only( bottom: 8),
																								width: 64,
																								height: 64,
																								child: ClipRRect(
																									borderRadius: BorderRadius.circular(32),
																									child: Image.network(
																										"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/apqpa6xd_expires_30_days.png",
																										fit: BoxFit.fill,
																									)
																								)
																							),
																							Text(
																								"Pizza",
																								style: TextStyle(
																									color: Color(0xFF1C1B1F),
																									fontSize: 13,
																									fontWeight: FontWeight.bold,
																								),
																							),
																						]
																					),
																				),
																			),
																		),
																		IntrinsicWidth(
																			child: IntrinsicHeight(
																				child: Container(
																					padding: const EdgeInsets.only( left: 4, right: 4),
																					margin: const EdgeInsets.only( right: 4),
																					child: Column(
																						children: [
																							Container(
																								decoration: BoxDecoration(
																									borderRadius: BorderRadius.circular(32),
																								),
																								margin: const EdgeInsets.only( bottom: 8),
																								width: 64,
																								height: 64,
																								child: ClipRRect(
																									borderRadius: BorderRadius.circular(32),
																									child: Image.network(
																										"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/fqse1a0o_expires_30_days.png",
																										fit: BoxFit.fill,
																									)
																								)
																							),
																							Text(
																								"Ramen",
																								style: TextStyle(
																									color: Color(0xFF1C1B1F),
																									fontSize: 13,
																									fontWeight: FontWeight.bold,
																								),
																							),
																						]
																					),
																				),
																			),
																		),
																		IntrinsicWidth(
																			child: IntrinsicHeight(
																				child: Container(
																					padding: const EdgeInsets.only( left: 4, right: 4),
																					child: Column(
																						children: [
																							Container(
																								decoration: BoxDecoration(
																									borderRadius: BorderRadius.circular(32),
																								),
																								margin: const EdgeInsets.only( bottom: 8),
																								width: 64,
																								height: 64,
																								child: ClipRRect(
																									borderRadius: BorderRadius.circular(32),
																									child: Image.network(
																										"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/tynp9l98_expires_30_days.png",
																										fit: BoxFit.fill,
																									)
																								)
																							),
																							Text(
																								"Burger",
																								style: TextStyle(
																									color: Color(0xFF1C1B1F),
																									fontSize: 13,
																									fontWeight: FontWeight.bold,
																								),
																							),
																						]
																					),
																				),
																			),
																		),
																	],
																)
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															color: Color(0xFFFFFFFF),
															padding: const EdgeInsets.only( top: 20, left: 20),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	Text(
																		"Fastest",
																		style: TextStyle(
																			color: Color(0xFF1C1B1F),
																			fontSize: 28,
																			fontWeight: FontWeight.bold,
																		),
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															color: Color(0xFFFFFFFF),
															padding: const EdgeInsets.symmetric(vertical: 10),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	Container(
																		decoration: BoxDecoration(
																			borderRadius: BorderRadius.circular(16),
																		),
																		margin: const EdgeInsets.only( bottom: 12, left: 20),
																		width: 228,
																		height: 156,
																		child: ClipRRect(
																			borderRadius: BorderRadius.circular(16),
																			child: Image.network(
																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/eapw4lzz_expires_30_days.png",
																				fit: BoxFit.fill,
																			)
																		)
																	),
																	IntrinsicHeight(
																		child: Container(
																			width: double.infinity,
																			child: SingleChildScrollView(
																				scrollDirection: Axis.horizontal,
																				child: Row(
																					crossAxisAlignment: CrossAxisAlignment.start,
																					children: [
																						IntrinsicWidth(
																							child: IntrinsicHeight(
																								child: Container(
																									padding: const EdgeInsets.only( right: 44),
																									margin: const EdgeInsets.only( left: 20, right: 12),
																									child: Column(
																										crossAxisAlignment: CrossAxisAlignment.start,
																										children: [
																											Container(
																												margin: const EdgeInsets.only( bottom: 4),
																												child: Text(
																													"Morning Delights Café",
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
																															IntrinsicWidth(
																																child: IntrinsicHeight(
																																	child: Container(
																																		margin: const EdgeInsets.only( right: 6),
																																		child: Row(
																																			children: [
																																				IntrinsicWidth(
																																					child: IntrinsicHeight(
																																						child: Container(
																																							margin: const EdgeInsets.only( right: 4),
																																							child: Row(
																																								children: [
																																									Container(
																																										margin: const EdgeInsets.only( right: 2),
																																										child: Text(
																																											"4.9",
																																											style: TextStyle(
																																												color: Color(0xFFFFA800),
																																												fontSize: 14,
																																												fontWeight: FontWeight.bold,
																																											),
																																										),
																																									),
																																									Container(
																																										width: 20,
																																										height: 20,
																																										child: Image.network(
																																											"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/k2oy23ed_expires_30_days.png",
																																											fit: BoxFit.fill,
																																										)
																																									),
																																								]
																																							),
																																						),
																																					),
																																				),
																																				Text(
																																					"(103)",
																																					style: TextStyle(
																																						color: Color(0xFFA09CAB),
																																						fontSize: 14,
																																					),
																																				),
																																			]
																																		),
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
																															Container(
																																margin: const EdgeInsets.only( right: 9),
																																child: Text(
																																	"2.3km",
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
																																"25 min",
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
																						IntrinsicWidth(
																							child: IntrinsicHeight(
																								child: Container(
																									padding: const EdgeInsets.only( right: 44),
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
																															IntrinsicWidth(
																																child: IntrinsicHeight(
																																	child: Container(
																																		margin: const EdgeInsets.only( right: 6),
																																		child: Row(
																																			children: [
																																				IntrinsicWidth(
																																					child: IntrinsicHeight(
																																						child: Container(
																																							margin: const EdgeInsets.only( right: 4),
																																							child: Row(
																																								children: [
																																									Container(
																																										margin: const EdgeInsets.only( right: 2),
																																										child: Text(
																																											"4.8",
																																											style: TextStyle(
																																												color: Color(0xFFFFA800),
																																												fontSize: 14,
																																												fontWeight: FontWeight.bold,
																																											),
																																										),
																																									),
																																									Container(
																																										width: 20,
																																										height: 20,
																																										child: Image.network(
																																											"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/i3ffu9m2_expires_30_days.png",
																																											fit: BoxFit.fill,
																																										)
																																									),
																																								]
																																							),
																																						),
																																					),
																																				),
																																				Text(
																																					"(561)",
																																					style: TextStyle(
																																						color: Color(0xFFA09CAB),
																																						fontSize: 14,
																																					),
																																				),
																																			]
																																		),
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
																															Container(
																																margin: const EdgeInsets.only( right: 9),
																																child: Text(
																																	"2.3km",
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
																																"21 min",
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
																					],
																				)
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
															padding: const EdgeInsets.only( top: 20, left: 20),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	Text(
																		"Recommended",
																		style: TextStyle(
																			color: Color(0xFF1C1B1F),
																			fontSize: 28,
																			fontWeight: FontWeight.bold,
																		),
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															color: Color(0xFFFFFFFF),
															width: double.infinity,
															child: Stack(
																clipBehavior: Clip.none,
																children: [
																	Padding(
																		padding: const EdgeInsets.only( top: 5, bottom: 5, left: 20, right: 20),
																		child: Column(
																			crossAxisAlignment: CrossAxisAlignment.start,
																			children: [
																				Container(
																					decoration: BoxDecoration(
																						borderRadius: BorderRadius.circular(16),
																					),
																					height: 171,
																					width: double.infinity,
																					child: ClipRRect(
																						borderRadius: BorderRadius.circular(16),
																						child: Image.network(
																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/94zjd26r_expires_30_days.png",
																							fit: BoxFit.fill,
																						)
																					)
																				),
																			]
																		),
																	),
																	Positioned(
																		bottom: 0,
																		left: 0,
																		right: 0,
																		child: IntrinsicHeight(
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
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															color: Color(0xFFFFFFFF),
															padding: const EdgeInsets.symmetric(vertical: 10),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	IntrinsicHeight(
																		child: Container(
																			padding: const EdgeInsets.only( left: 36, right: 36),
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
																												"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/w9h1m1ib_expires_30_days.png",
																												fit: BoxFit.fill,
																											)
																										),
																										Text(
																											"Home",
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
																								margin: const EdgeInsets.only( right: 37),
																								width: double.infinity,
																								child: Column(
																									children: [
																										Container(
																											margin: const EdgeInsets.only( bottom: 3),
																											width: 24,
																											height: 24,
																											child: Image.network(
																												"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/7p6o9ykk_expires_30_days.png",
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
																												"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/9w1cs31t_expires_30_days.png",
																												fit: BoxFit.fill,
																											)
																										),
																										Text(
																											"Orders",
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
																								width: double.infinity,
																								child: Column(
																									children: [
																										Container(
																											margin: const EdgeInsets.only( bottom: 3),
																											width: 24,
																											height: 24,
																											child: Image.network(
																												"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/9l3e2ty8_expires_30_days.png",
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