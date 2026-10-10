import 'package:flutter/material.dart';
class ResturauntScroll extends StatefulWidget {
	const ResturauntScroll({super.key});
	@override
	ResturauntScrollState createState() => ResturauntScrollState();
}
class ResturauntScrollState extends State<ResturauntScroll> {
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
											padding: const EdgeInsets.only( bottom: 2),
											child: Column(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: [
													IntrinsicHeight(
														child: Container(
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
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/qswf76d4_expires_30_days.png",
																			fit: BoxFit.fill,
																		)
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															padding: const EdgeInsets.only( top: 12, bottom: 12, left: 16, right: 16),
															width: double.infinity,
															child: Row(
																mainAxisAlignment: MainAxisAlignment.spaceBetween,
																children: [
																	Container(
																		width: 24,
																		height: 24,
																		child: Image.network(
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/jdfpv8nj_expires_30_days.png",
																			fit: BoxFit.fill,
																		)
																	),
																	Container(
																		width: 84,
																		height: 24,
																		child: Image.network(
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/42z8xokj_expires_30_days.png",
																			fit: BoxFit.fill,
																		)
																	),
																]
															),
														),
													),
													IntrinsicWidth(
														child: IntrinsicHeight(
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
																						decoration: BoxDecoration(
																							borderRadius: BorderRadius.circular(12),
																						),
																						padding: const EdgeInsets.symmetric(vertical: 16),
																						margin: const EdgeInsets.only( right: 20),
																						child: Column(
																							children: [
																								Text(
																									"Popular",
																									style: TextStyle(
																										color: Color(0xFF1C1B1F),
																										fontSize: 16,
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
																						padding: const EdgeInsets.symmetric(vertical: 16),
																						margin: const EdgeInsets.only( right: 20),
																						child: Column(
																							children: [
																								Text(
																									"New",
																									style: TextStyle(
																										color: Color(0xFF00C773),
																										fontSize: 16,
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
																						decoration: BoxDecoration(
																							borderRadius: BorderRadius.circular(12),
																						),
																						padding: const EdgeInsets.symmetric(vertical: 16),
																						margin: const EdgeInsets.only( right: 20),
																						child: Column(
																							children: [
																								Text(
																									"Tacos",
																									style: TextStyle(
																										color: Color(0xFF1C1B1F),
																										fontSize: 16,
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
																						decoration: BoxDecoration(
																							borderRadius: BorderRadius.circular(12),
																						),
																						padding: const EdgeInsets.symmetric(vertical: 16),
																						margin: const EdgeInsets.only( right: 20),
																						child: Column(
																							children: [
																								Text(
																									"Tortillas",
																									style: TextStyle(
																										color: Color(0xFF1C1B1F),
																										fontSize: 16,
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
																						decoration: BoxDecoration(
																							borderRadius: BorderRadius.circular(12),
																						),
																						padding: const EdgeInsets.symmetric(vertical: 16),
																						margin: const EdgeInsets.only( right: 20),
																						child: Column(
																							children: [
																								Text(
																									"Buritos",
																									style: TextStyle(
																										color: Color(0xFF1C1B1F),
																										fontSize: 16,
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
																						padding: const EdgeInsets.symmetric(vertical: 16),
																						margin: const EdgeInsets.only( right: 20),
																						child: Column(
																							children: [
																								Text(
																									"Grill",
																									style: TextStyle(
																										color: Color(0xFF00C773),
																										fontSize: 16,
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
													),
													IntrinsicHeight(
														child: Container(
															padding: const EdgeInsets.only( top: 12, bottom: 12, left: 20, right: 20),
															width: double.infinity,
															child: Row(
																children: [
																	Container(
																		decoration: BoxDecoration(
																			borderRadius: BorderRadius.circular(12),
																		),
																		margin: const EdgeInsets.only( right: 12),
																		width: 88,
																		height: 64,
																		child: ClipRRect(
																			borderRadius: BorderRadius.circular(12),
																			child: Image.network(
																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/30qnhi5v_expires_30_days.png",
																				fit: BoxFit.fill,
																			)
																		)
																	),
																	Expanded(
																		child: IntrinsicHeight(
																			child: Container(
																				margin: const EdgeInsets.only( right: 12),
																				width: double.infinity,
																				child: Column(
																					crossAxisAlignment: CrossAxisAlignment.start,
																					children: [
																						Container(
																							margin: const EdgeInsets.only( bottom: 4),
																							child: Text(
																								"Cheese Quesadillas",
																								style: TextStyle(
																									color: Color(0xFF1C1B1F),
																									fontSize: 16,
																									fontWeight: FontWeight.bold,
																								),
																							),
																						),
																						Text(
																							"\$10.99",
																							style: TextStyle(
																								color: Color(0xFF1C1B1F),
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
																			borderRadius: BorderRadius.circular(12),
																		),
																		width: 40,
																		height: 36,
																		child: ClipRRect(
																			borderRadius: BorderRadius.circular(12),
																			child: Image.network(
																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/yck6julz_expires_30_days.png",
																				fit: BoxFit.fill,
																			)
																		)
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
																		margin: const EdgeInsets.only( bottom: 4),
																		child: Text(
																			"New",
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
																			borderRadius: BorderRadius.circular(12),
																		),
																		margin: const EdgeInsets.only( right: 12),
																		width: 88,
																		height: 64,
																		child: ClipRRect(
																			borderRadius: BorderRadius.circular(12),
																			child: Image.network(
																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/o8amfxdl_expires_30_days.png",
																				fit: BoxFit.fill,
																			)
																		)
																	),
																	Expanded(
																		child: IntrinsicHeight(
																			child: Container(
																				margin: const EdgeInsets.only( right: 12),
																				width: double.infinity,
																				child: Column(
																					crossAxisAlignment: CrossAxisAlignment.start,
																					children: [
																						Container(
																							margin: const EdgeInsets.only( bottom: 4),
																							child: Text(
																								"Fajitas",
																								style: TextStyle(
																									color: Color(0xFF1C1B1F),
																									fontSize: 16,
																									fontWeight: FontWeight.bold,
																								),
																							),
																						),
																						Text(
																							"\$16.99",
																							style: TextStyle(
																								color: Color(0xFF1C1B1F),
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
																			borderRadius: BorderRadius.circular(12),
																		),
																		width: 40,
																		height: 36,
																		child: ClipRRect(
																			borderRadius: BorderRadius.circular(12),
																			child: Image.network(
																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/c1dx1r2a_expires_30_days.png",
																				fit: BoxFit.fill,
																			)
																		)
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
																			borderRadius: BorderRadius.circular(12),
																		),
																		margin: const EdgeInsets.only( right: 12),
																		width: 88,
																		height: 64,
																		child: ClipRRect(
																			borderRadius: BorderRadius.circular(12),
																			child: Image.network(
																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/c4by5n02_expires_30_days.png",
																				fit: BoxFit.fill,
																			)
																		)
																	),
																	Expanded(
																		child: IntrinsicHeight(
																			child: Container(
																				margin: const EdgeInsets.only( right: 12),
																				width: double.infinity,
																				child: Column(
																					crossAxisAlignment: CrossAxisAlignment.start,
																					children: [
																						Container(
																							margin: const EdgeInsets.only( bottom: 4),
																							child: Text(
																								"Tacos de Rajas",
																								style: TextStyle(
																									color: Color(0xFF1C1B1F),
																									fontSize: 16,
																									fontWeight: FontWeight.bold,
																								),
																							),
																						),
																						Text(
																							"\$14.99",
																							style: TextStyle(
																								color: Color(0xFF1C1B1F),
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
																			borderRadius: BorderRadius.circular(12),
																		),
																		width: 40,
																		height: 36,
																		child: ClipRRect(
																			borderRadius: BorderRadius.circular(12),
																			child: Image.network(
																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/a8q1oel9_expires_30_days.png",
																				fit: BoxFit.fill,
																			)
																		)
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
																			borderRadius: BorderRadius.circular(12),
																		),
																		margin: const EdgeInsets.only( right: 12),
																		width: 88,
																		height: 64,
																		child: ClipRRect(
																			borderRadius: BorderRadius.circular(12),
																			child: Image.network(
																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/knrnrkjq_expires_30_days.png",
																				fit: BoxFit.fill,
																			)
																		)
																	),
																	Expanded(
																		child: IntrinsicHeight(
																			child: Container(
																				margin: const EdgeInsets.only( right: 12),
																				width: double.infinity,
																				child: Column(
																					crossAxisAlignment: CrossAxisAlignment.start,
																					children: [
																						Container(
																							margin: const EdgeInsets.only( bottom: 4),
																							child: Text(
																								"Chiles Rellenos",
																								style: TextStyle(
																									color: Color(0xFF1C1B1F),
																									fontSize: 16,
																									fontWeight: FontWeight.bold,
																								),
																							),
																						),
																						Text(
																							"\$23.99",
																							style: TextStyle(
																								color: Color(0xFF1C1B1F),
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
																			borderRadius: BorderRadius.circular(12),
																		),
																		width: 40,
																		height: 36,
																		child: ClipRRect(
																			borderRadius: BorderRadius.circular(12),
																			child: Image.network(
																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/dqaq2l7d_expires_30_days.png",
																				fit: BoxFit.fill,
																			)
																		)
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
																		margin: const EdgeInsets.only( bottom: 4),
																		child: Text(
																			"Tacos",
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
																			borderRadius: BorderRadius.circular(12),
																		),
																		margin: const EdgeInsets.only( right: 12),
																		width: 88,
																		height: 64,
																		child: ClipRRect(
																			borderRadius: BorderRadius.circular(12),
																			child: Image.network(
																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/clvngn8r_expires_30_days.png",
																				fit: BoxFit.fill,
																			)
																		)
																	),
																	Expanded(
																		child: IntrinsicHeight(
																			child: Container(
																				margin: const EdgeInsets.only( right: 12),
																				width: double.infinity,
																				child: Column(
																					crossAxisAlignment: CrossAxisAlignment.start,
																					children: [
																						Container(
																							margin: const EdgeInsets.only( bottom: 4),
																							child: Text(
																								"Tacos al Pastor",
																								style: TextStyle(
																									color: Color(0xFF1C1B1F),
																									fontSize: 16,
																									fontWeight: FontWeight.bold,
																								),
																							),
																						),
																						Text(
																							"\$14.99",
																							style: TextStyle(
																								color: Color(0xFF1C1B1F),
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
																			borderRadius: BorderRadius.circular(12),
																		),
																		width: 40,
																		height: 36,
																		child: ClipRRect(
																			borderRadius: BorderRadius.circular(12),
																			child: Image.network(
																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/2a4s7tqm_expires_30_days.png",
																				fit: BoxFit.fill,
																			)
																		)
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	IntrinsicHeight(
																		child: Container(
																			padding: const EdgeInsets.only( top: 12, bottom: 12, left: 20, right: 20),
																			width: double.infinity,
																			child: Row(
																				children: [
																					Container(
																						decoration: BoxDecoration(
																							borderRadius: BorderRadius.circular(12),
																						),
																						margin: const EdgeInsets.only( right: 12),
																						width: 88,
																						height: 64,
																						child: ClipRRect(
																							borderRadius: BorderRadius.circular(12),
																							child: Image.network(
																								"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/0qa1ztqu_expires_30_days.png",
																								fit: BoxFit.fill,
																							)
																						)
																					),
																					Expanded(
																						child: IntrinsicHeight(
																							child: Container(
																								margin: const EdgeInsets.only( right: 12),
																								width: double.infinity,
																								child: Column(
																									crossAxisAlignment: CrossAxisAlignment.start,
																									children: [
																										Container(
																											margin: const EdgeInsets.only( bottom: 4),
																											child: Text(
																												"Carne Asada Tacos",
																												style: TextStyle(
																													color: Color(0xFF1C1B1F),
																													fontSize: 16,
																													fontWeight: FontWeight.bold,
																												),
																											),
																										),
																										Text(
																											"\$12.99",
																											style: TextStyle(
																												color: Color(0xFF1C1B1F),
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
																							borderRadius: BorderRadius.circular(12),
																						),
																						width: 40,
																						height: 36,
																						child: ClipRRect(
																							borderRadius: BorderRadius.circular(12),
																							child: Image.network(
																								"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/e9dxatcw_expires_30_days.png",
																								fit: BoxFit.fill,
																							)
																						)
																					),
																				]
																			),
																		),
																	),
																]
															),
														),
													),
													Container(
														color: Color(0xFFFFFFFF),
														height: 21,
														width: double.infinity,
														child: SizedBox(),
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