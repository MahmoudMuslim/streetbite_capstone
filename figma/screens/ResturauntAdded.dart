import 'package:flutter/material.dart';
class ResturauntAdded extends StatefulWidget {
	const ResturauntAdded({super.key});
	@override
	ResturauntAddedState createState() => ResturauntAddedState();
}
class ResturauntAddedState extends State<ResturauntAdded> {
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
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/blefij9z_expires_30_days.png",
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
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/5p03rlpq_expires_30_days.png",
																			fit: BoxFit.fill,
																		)
																	),
																	Container(
																		width: 84,
																		height: 24,
																		child: Image.network(
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/hkfowj8v_expires_30_days.png",
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
																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/dj0xmd00_expires_30_days.png",
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
																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/la1i4lym_expires_30_days.png",
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
																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/tocan3j8_expires_30_days.png",
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
																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/5zhrjd4v_expires_30_days.png",
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
																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/xclbpn0i_expires_30_days.png",
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
																	InkWell(
																		onTap: () { print('Pressed'); },
																		child: IntrinsicWidth(
																			child: IntrinsicHeight(
																				child: Container(
																					decoration: BoxDecoration(
																						border: Border.all(
																							color: Color(0xFFF7F7F7),
																							width: 2,
																						),
																						borderRadius: BorderRadius.circular(12),
																						color: Color(0xFFFFFFFF),
																					),
																					padding: const EdgeInsets.only( top: 6, bottom: 6, left: 8, right: 8),
																					child: Row(
																						children: [
																							Container(
																								margin: const EdgeInsets.only( right: 6),
																								width: 24,
																								height: 24,
																								child: Image.network(
																									"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/zftpyzxa_expires_30_days.png",
																									fit: BoxFit.fill,
																								)
																							),
																							Container(
																								margin: const EdgeInsets.only( right: 3),
																								child: Text(
																									"2",
																									style: TextStyle(
																										color: Color(0xFF1C1B1F),
																										fontSize: 14,
																										fontWeight: FontWeight.bold,
																									),
																								),
																							),
																							Container(
																								width: 24,
																								height: 24,
																								child: Image.network(
																									"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/rge0vhzk_expires_30_days.png",
																									fit: BoxFit.fill,
																								)
																							),
																						]
																					),
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
																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/a2zyyrsn_expires_30_days.png",
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
																	InkWell(
																		onTap: () { print('Pressed'); },
																		child: IntrinsicWidth(
																			child: IntrinsicHeight(
																				child: Container(
																					decoration: BoxDecoration(
																						border: Border.all(
																							color: Color(0xFFF7F7F7),
																							width: 2,
																						),
																						borderRadius: BorderRadius.circular(12),
																						color: Color(0xFFFFFFFF),
																					),
																					padding: const EdgeInsets.only( top: 6, bottom: 6, left: 8, right: 8),
																					child: Row(
																						children: [
																							Container(
																								margin: const EdgeInsets.only( right: 6),
																								width: 24,
																								height: 24,
																								child: Image.network(
																									"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/eurnrs33_expires_30_days.png",
																									fit: BoxFit.fill,
																								)
																							),
																							Container(
																								margin: const EdgeInsets.only( right: 5),
																								child: Text(
																									"1",
																									style: TextStyle(
																										color: Color(0xFF1C1B1F),
																										fontSize: 14,
																										fontWeight: FontWeight.bold,
																									),
																								),
																							),
																							Container(
																								width: 24,
																								height: 24,
																								child: Image.network(
																									"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/zqjf5cv5_expires_30_days.png",
																									fit: BoxFit.fill,
																								)
																							),
																						]
																					),
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
															margin: const EdgeInsets.only( bottom: 69),
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
																								"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/u35md55o_expires_30_days.png",
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
																								"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/oglvupi4_expires_30_days.png",
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
													IntrinsicHeight(
														child: Container(
															color: Color(0xFFFFFFFF),
															padding: const EdgeInsets.symmetric(vertical: 14),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	InkWell(
																		onTap: () { print('Pressed'); },
																		child: IntrinsicHeight(
																			child: Container(
																				decoration: BoxDecoration(
																					borderRadius: BorderRadius.circular(28),
																					color: Color(0xFF00C773),
																				),
																				padding: const EdgeInsets.symmetric(vertical: 14),
																				margin: const EdgeInsets.symmetric(horizontal: 16),
																				width: double.infinity,
																				child: Column(
																					children: [
																						Text(
																							"Continue",
																							style: TextStyle(
																								color: Color(0xFFFFFFFF),
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