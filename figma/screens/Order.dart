import 'package:flutter/material.dart';
class Order extends StatefulWidget {
	const Order({super.key});
	@override
	OrderState createState() => OrderState();
}
class OrderState extends State<Order> {
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
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/l8d5orqq_expires_30_days.png",
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
															padding: const EdgeInsets.only( top: 12, bottom: 12, left: 16, right: 16),
															width: double.infinity,
															child: Row(
																children: [
																	Container(
																		margin: const EdgeInsets.only( right: 24),
																		width: 24,
																		height: 24,
																		child: Image.network(
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/2f17wiqf_expires_30_days.png",
																			fit: BoxFit.fill,
																		)
																	),
																	Expanded(
																		child: IntrinsicHeight(
																			child: Container(
																				decoration: BoxDecoration(
																					borderRadius: BorderRadius.circular(52),
																					color: Color(0xFFE5F9F1),
																				),
																				margin: const EdgeInsets.only( right: 24),
																				width: double.infinity,
																				child: Row(
																					children: [
																						Expanded(
																							child: InkWell(
																								onTap: () { print('Pressed'); },
																								child: IntrinsicHeight(
																									child: Container(
																										decoration: BoxDecoration(
																											borderRadius: BorderRadius.circular(35),
																											color: Color(0xFF00C773),
																											boxShadow: [
																												BoxShadow(
																													color: Color(0x0D000000),
																													blurRadius: 4,
																													offset: Offset(0, 4),
																												),
																											],
																										),
																										padding: const EdgeInsets.symmetric(vertical: 10),
																										margin: const EdgeInsets.only( right: 7),
																										width: double.infinity,
																										child: Column(
																											children: [
																												Text(
																													"Delivery",
																													style: TextStyle(
																														color: Color(0xFFFFFFFF),
																														fontSize: 14,
																														fontWeight: FontWeight.bold,
																													),
																												),
																											]
																										),
																									),
																								),
																							),
																						),
																						Expanded(
																							child: IntrinsicHeight(
																								child: Container(
																									decoration: BoxDecoration(
																										borderRadius: BorderRadius.circular(12),
																									),
																									padding: const EdgeInsets.symmetric(vertical: 10),
																									width: double.infinity,
																									child: Column(
																										children: [
																											Text(
																												"Pickup",
																												style: TextStyle(
																													color: Color(0xFF00C773),
																													fontSize: 14,
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
													IntrinsicHeight(
														child: Container(
															color: Color(0xFFFFFFFF),
															padding: const EdgeInsets.only( top: 28, left: 20),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	Container(
																		margin: const EdgeInsets.only( bottom: 8),
																		child: Text(
																			"Order",
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
															padding: const EdgeInsets.only( top: 8, bottom: 8, left: 20, right: 20),
															width: double.infinity,
															child: Row(
																children: [
																	Container(
																		decoration: BoxDecoration(
																			borderRadius: BorderRadius.circular(12),
																		),
																		margin: const EdgeInsets.only( right: 12),
																		width: 64,
																		height: 64,
																		child: ClipRRect(
																			borderRadius: BorderRadius.circular(12),
																			child: Image.network(
																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/crzj0zg6_expires_30_days.png",
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
																									"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/43mhxdou_expires_30_days.png",
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
																									"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/hx5h0udl_expires_30_days.png",
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
															padding: const EdgeInsets.only( top: 8, bottom: 8, left: 20, right: 20),
															width: double.infinity,
															child: Row(
																children: [
																	Container(
																		decoration: BoxDecoration(
																			borderRadius: BorderRadius.circular(12),
																		),
																		margin: const EdgeInsets.only( right: 12),
																		width: 64,
																		height: 64,
																		child: ClipRRect(
																			borderRadius: BorderRadius.circular(12),
																			child: Image.network(
																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/r2a9tgpf_expires_30_days.png",
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
																									"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/d7t98b7u_expires_30_days.png",
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
																									"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/57xmg992_expires_30_days.png",
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
															padding: const EdgeInsets.only( top: 8, bottom: 8, left: 20, right: 20),
															width: double.infinity,
															child: Row(
																children: [
																	Container(
																		decoration: BoxDecoration(
																			borderRadius: BorderRadius.circular(12),
																		),
																		margin: const EdgeInsets.only( right: 12),
																		width: 64,
																		height: 64,
																		child: ClipRRect(
																			borderRadius: BorderRadius.circular(12),
																			child: Image.network(
																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/xde1oi5e_expires_30_days.png",
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
																									"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/3y97ezma_expires_30_days.png",
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
																									"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/1rvgv52d_expires_30_days.png",
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
															padding: const EdgeInsets.only( top: 16, bottom: 16, left: 20),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	Text(
																		"See menu",
																		style: TextStyle(
																			color: Color(0xFF00C773),
																			fontSize: 16,
																			fontWeight: FontWeight.bold,
																		),
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															margin: const EdgeInsets.only( bottom: 37),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	IntrinsicHeight(
																		child: Container(
																			color: Color(0xFFFFFFFF),
																			padding: const EdgeInsets.only( top: 12, bottom: 12, left: 20, right: 20),
																			width: double.infinity,
																			child: Column(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					IntrinsicHeight(
																						child: Container(
																							color: Color(0xFFFFFFFF),
																							padding: const EdgeInsets.symmetric(vertical: 8),
																							width: double.infinity,
																							child: Row(
																								mainAxisAlignment: MainAxisAlignment.spaceBetween,
																								children: [
																									Text(
																										"Order",
																										style: TextStyle(
																											color: Color(0xFF1C1B1F),
																											fontSize: 16,
																										),
																									),
																									Text(
																										"\$37.99",
																										style: TextStyle(
																											color: Color(0xFF1C1B1F),
																											fontSize: 16,
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
																							child: Row(
																								mainAxisAlignment: MainAxisAlignment.spaceBetween,
																								children: [
																									Text(
																										"Delivery fee",
																										style: TextStyle(
																											color: Color(0xFF1C1B1F),
																											fontSize: 16,
																										),
																									),
																									Text(
																										"\$3.99",
																										style: TextStyle(
																											color: Color(0xFF1C1B1F),
																											fontSize: 16,
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
																							child: Row(
																								mainAxisAlignment: MainAxisAlignment.spaceBetween,
																								children: [
																									Text(
																										"Fees & Taxes",
																										style: TextStyle(
																											color: Color(0xFF1C1B1F),
																											fontSize: 16,
																										),
																									),
																									Text(
																										"\$2.45",
																										style: TextStyle(
																											color: Color(0xFF1C1B1F),
																											fontSize: 16,
																										),
																									),
																								]
																							),
																						),
																					),
																					IntrinsicHeight(
																						child: Container(
																							padding: const EdgeInsets.symmetric(vertical: 8),
																							width: double.infinity,
																							child: Row(
																								mainAxisAlignment: MainAxisAlignment.spaceBetween,
																								children: [
																									Text(
																										"Discount",
																										style: TextStyle(
																											color: Color(0xFF00C773),
																											fontSize: 16,
																											fontWeight: FontWeight.bold,
																										),
																									),
																									Text(
																										"-\$4.56",
																										style: TextStyle(
																											color: Color(0xFF00C773),
																											fontSize: 16,
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
																							padding: const EdgeInsets.symmetric(vertical: 8),
																							width: double.infinity,
																							child: Row(
																								mainAxisAlignment: MainAxisAlignment.spaceBetween,
																								children: [
																									Text(
																										"Subtotal",
																										style: TextStyle(
																											color: Color(0xFF1C1B1F),
																											fontSize: 24,
																											fontWeight: FontWeight.bold,
																										),
																									),
																									Text(
																										"\$34.97",
																										style: TextStyle(
																											color: Color(0xFF1C1B1F),
																											fontSize: 24,
																											fontWeight: FontWeight.bold,
																										),
																									),
																								]
																							),
																						),
																					),
																					Container(
																						color: Color(0xFFFFFFFF),
																						height: 40,
																						width: double.infinity,
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
															padding: const EdgeInsets.only( top: 14, bottom: 14, left: 16, right: 16),
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