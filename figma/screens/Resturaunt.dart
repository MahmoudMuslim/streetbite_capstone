import 'package:flutter/material.dart';
class Resturaunt extends StatefulWidget {
	const Resturaunt({super.key});
	@override
	ResturauntState createState() => ResturauntState();
}
class ResturauntState extends State<Resturaunt> {
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
															padding: const EdgeInsets.only( bottom: 134),
															width: double.infinity,
															decoration: BoxDecoration(
																image: DecorationImage(
																	image: NetworkImage("https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/pz9h7bqa_expires_30_days.png"),
																	fit: BoxFit.fill
																),
															),
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
																								color: Color(0xFFFFFFFF),
																								fontSize: 17,
																								fontWeight: FontWeight.bold,
																							),
																						),
																					),
																					Container(
																						width: 134,
																						height: 54,
																						child: Image.network(
																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/suj9s016_expires_30_days.png",
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
																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/4i0zsqym_expires_30_days.png",
																							fit: BoxFit.fill,
																						)
																					),
																					Container(
																						width: 84,
																						height: 24,
																						child: Image.network(
																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/p100u2ts_expires_30_days.png",
																							fit: BoxFit.fill,
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
													IntrinsicHeight(
														child: Container(
															color: Color(0xFFFFFFFF),
															padding: const EdgeInsets.only( top: 28),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	Container(
																		margin: const EdgeInsets.only( bottom: 4, left: 20),
																		child: Text(
																			"Sabor Mexicano Grill",
																			style: TextStyle(
																				color: Color(0xFF1C1B1F),
																				fontSize: 36,
																				fontWeight: FontWeight.bold,
																			),
																		),
																	),
																	IntrinsicWidth(
																		child: IntrinsicHeight(
																			child: Container(
																				margin: const EdgeInsets.only( bottom: 16, left: 20),
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
																																	margin: const EdgeInsets.only( right: 3),
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
																																		"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/2r749ux8_expires_30_days.png",
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
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															decoration: BoxDecoration(
																borderRadius: BorderRadius.circular(16),
																color: Color(0xFF00C773),
															),
															padding: const EdgeInsets.all(20),
															margin: const EdgeInsets.symmetric(horizontal: 20),
															width: double.infinity,
															child: Row(
																children: [
																	Expanded(
																		child: IntrinsicHeight(
																			child: Container(
																				padding: const EdgeInsets.only( right: 19),
																				margin: const EdgeInsets.only( right: 12),
																				width: double.infinity,
																				child: Column(
																					crossAxisAlignment: CrossAxisAlignment.start,
																					children: [
																						Container(
																							margin: const EdgeInsets.only( bottom: 2),
																							width: double.infinity,
																							child: Text(
																								"\$0 delivery fee over \$30",
																								style: TextStyle(
																									color: Color(0xFFFFFFFF),
																									fontSize: 21,
																									fontWeight: FontWeight.bold,
																								),
																							),
																						),
																						Container(
																							width: double.infinity,
																							child: Text(
																								"Use WELCOME30 promo code on any order",
																								style: TextStyle(
																									color: Color(0xFFFFFFFF),
																									fontSize: 14,
																								),
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
																		width: 64,
																		height: 68,
																		child: ClipRRect(
																			borderRadius: BorderRadius.circular(12),
																			child: Image.network(
																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/wyyzp65d_expires_30_days.png",
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
																			"Popular",
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
																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/tcr5e3a2_expires_30_days.png",
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
																								"Tacos",
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
																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/lpcodt69_expires_30_days.png",
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
																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/16fkevw6_expires_30_days.png",
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
																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/1sggqs6h_expires_30_days.png",
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
																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/jdzt51ia_expires_30_days.png",
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
																								"Churros",
																								style: TextStyle(
																									color: Color(0xFF1C1B1F),
																									fontSize: 16,
																									fontWeight: FontWeight.bold,
																								),
																							),
																						),
																						Text(
																							"\$6.99",
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
																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/t88n5amr_expires_30_days.png",
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
															child: Stack(
																clipBehavior: Clip.none,
																children: [
																	Padding(
																		padding: const EdgeInsets.only( top: 20),
																		child: Column(
																			children: [
																				Text(
																					"Tacos al Pastor",
																					style: TextStyle(
																						color: Color(0xFF1C1B1F),
																						fontSize: 16,
																						fontWeight: FontWeight.bold,
																					),
																				),
																			]
																		),
																	),
																	Positioned(
																		bottom: 0,
																		left: 20,
																		width: 88,
																		height: 20,
																		child: Container(
																			decoration: BoxDecoration(
																				borderRadius: BorderRadius.circular(12),
																			),
																			width: 88,
																			height: 20,
																			child: ClipRRect(
																				borderRadius: BorderRadius.circular(12),
																				child: Image.network(
																					"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/wevzaxss_expires_30_days.png",
																					fit: BoxFit.fill,
																				)
																			)
																		),
																	),
																	Positioned(
																		bottom: 0,
																		right: 20,
																		width: 40,
																		height: 6,
																		child: Container(
																			decoration: BoxDecoration(
																				borderRadius: BorderRadius.circular(12),
																			),
																			width: 40,
																			height: 6,
																			child: ClipRRect(
																				borderRadius: BorderRadius.circular(12),
																				child: Image.network(
																					"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/rfgqcsjv_expires_30_days.png",
																					fit: BoxFit.fill,
																				)
																			)
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