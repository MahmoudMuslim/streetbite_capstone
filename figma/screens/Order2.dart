import 'package:flutter/material.dart';
class Order2 extends StatefulWidget {
	const Order2({super.key});
	@override
	Order2State createState() => Order2State();
}
class Order2State extends State<Order2> {
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
															child: Stack(
																clipBehavior: Clip.none,
																children: [
																	Column(
																		crossAxisAlignment: CrossAxisAlignment.start,
																		children: [
																			Container(
																				height: 253,
																				width: double.infinity,
																				child: SizedBox(),
																			),
																		]
																	),
																	Positioned(
																		top: 0,
																		bottom: 0,
																		left: 0,
																		right: 0,
																		child: IntrinsicHeight(
																			child: Container(
																				padding: const EdgeInsets.only( bottom: 56),
																				width: double.infinity,
																				decoration: BoxDecoration(
																					image: DecorationImage(
																						image: NetworkImage("https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/p892arjl_expires_30_days.png"),
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
																												"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/2ezvwum6_expires_30_days.png",
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
																								margin: const EdgeInsets.only( bottom: 31),
																								width: double.infinity,
																								child: Row(
																									mainAxisAlignment: MainAxisAlignment.spaceBetween,
																									children: [
																										Container(
																											decoration: BoxDecoration(
																												borderRadius: BorderRadius.circular(24),
																											),
																											width: 40,
																											height: 40,
																											child: ClipRRect(
																												borderRadius: BorderRadius.circular(24),
																												child: Image.network(
																													"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/zq9qiuxe_expires_30_days.png",
																													fit: BoxFit.fill,
																												)
																											)
																										),
																										IntrinsicWidth(
																											child: IntrinsicHeight(
																												child: Container(
																													decoration: BoxDecoration(
																														color: Color(0xFFFFFFFF),
																														boxShadow: [
																															BoxShadow(
																																color: Color(0x33000000),
																																blurRadius: 12,
																																offset: Offset(0, 4),
																															),
																														],
																													),
																													child: Row(
																														children: [
																															InkWell(
																																onTap: () { print('Pressed'); },
																																child: IntrinsicWidth(
																																	child: IntrinsicHeight(
																																		child: Container(
																																			decoration: BoxDecoration(
																																				borderRadius: BorderRadius.circular(24),
																																				color: Color(0xFFFFFFFF),
																																			),
																																			padding: const EdgeInsets.only( top: 8, bottom: 8, left: 12, right: 12),
																																			margin: const EdgeInsets.only( right: 6),
																																			child: Column(
																																				crossAxisAlignment: CrossAxisAlignment.start,
																																				children: [
																																					Text(
																																						"Help",
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
																															),
																															Container(
																																decoration: BoxDecoration(
																																	borderRadius: BorderRadius.circular(24),
																																),
																																width: 40,
																																height: 40,
																																child: ClipRRect(
																																	borderRadius: BorderRadius.circular(24),
																																	child: Image.network(
																																		"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/1frprpm3_expires_30_days.png",
																																		fit: BoxFit.fill,
																																	)
																																)
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
																								width: double.infinity,
																								child: Column(
																									crossAxisAlignment: CrossAxisAlignment.end,
																									children: [
																										Container(
																											margin: const EdgeInsets.only( right: 75),
																											width: 40,
																											height: 48,
																											child: Image.network(
																												"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/wih9ttqy_expires_30_days.png",
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
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															decoration: BoxDecoration(
																borderRadius: BorderRadius.only(
																	topLeft: Radius.circular(24),
																	topRight: Radius.circular(24),
																),
																color: Color(0xFFFFFFFF),
																boxShadow: [
																	BoxShadow(
																		color: Color(0x12000000),
																		blurRadius: 16,
																		offset: Offset(0, -12),
																	),
																],
															),
															padding: const EdgeInsets.only( top: 28, left: 20),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	Container(
																		margin: const EdgeInsets.only( bottom: 4),
																		child: Text(
																			"Arrives in 25-30 min",
																			style: TextStyle(
																				color: Color(0xFF00C773),
																				fontSize: 20,
																				fontWeight: FontWeight.bold,
																			),
																		),
																	),
																	Container(
																		margin: const EdgeInsets.only( bottom: 12),
																		child: Text(
																			"Preparing your order",
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
															padding: const EdgeInsets.only( top: 8),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	IntrinsicHeight(
																		child: Container(
																			padding: const EdgeInsets.only( right: 16),
																			width: double.infinity,
																			child: Column(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					Container(
																						margin: const EdgeInsets.only( left: 16),
																						width: 40,
																						height: 12,
																						child: Image.network(
																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/6pstiv42_expires_30_days.png",
																							fit: BoxFit.fill,
																						)
																					),
																					IntrinsicHeight(
																						child: Container(
																							margin: const EdgeInsets.only( left: 16),
																							width: double.infinity,
																							child: Row(
																								children: [
																									Container(
																										margin: const EdgeInsets.only( right: 12),
																										width: 40,
																										height: 40,
																										child: Image.network(
																											"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/zm61g9vd_expires_30_days.png",
																											fit: BoxFit.fill,
																										)
																									),
																									Text(
																										"Order received ",
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
																					Container(
																						margin: const EdgeInsets.only( left: 16),
																						width: 40,
																						height: 12,
																						child: Image.network(
																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/108s7ekc_expires_30_days.png",
																							fit: BoxFit.fill,
																						)
																					),
																				]
																			),
																		),
																	),
																	IntrinsicHeight(
																		child: Container(
																			padding: const EdgeInsets.only( right: 16),
																			width: double.infinity,
																			child: Column(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					Container(
																						margin: const EdgeInsets.only( left: 16),
																						width: 40,
																						height: 12,
																						child: Image.network(
																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/xsidwopy_expires_30_days.png",
																							fit: BoxFit.fill,
																						)
																					),
																					IntrinsicHeight(
																						child: Container(
																							margin: const EdgeInsets.only( left: 16),
																							width: double.infinity,
																							child: Row(
																								children: [
																									Container(
																										margin: const EdgeInsets.only( right: 12),
																										width: 40,
																										height: 40,
																										child: Image.network(
																											"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/os94l7qy_expires_30_days.png",
																											fit: BoxFit.fill,
																										)
																									),
																									Expanded(
																										child: IntrinsicHeight(
																											child: Container(
																												width: double.infinity,
																												child: Column(
																													crossAxisAlignment: CrossAxisAlignment.start,
																													children: [
																														Text(
																															"Cooking your order ",
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
																					Container(
																						margin: const EdgeInsets.only( left: 16),
																						width: 40,
																						height: 12,
																						child: Image.network(
																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/9rvd88xl_expires_30_days.png",
																							fit: BoxFit.fill,
																						)
																					),
																				]
																			),
																		),
																	),
																	IntrinsicHeight(
																		child: Container(
																			padding: const EdgeInsets.only( right: 16),
																			width: double.infinity,
																			child: Column(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					Container(
																						margin: const EdgeInsets.only( left: 16),
																						width: 40,
																						height: 12,
																						child: Image.network(
																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/n9le16b6_expires_30_days.png",
																							fit: BoxFit.fill,
																						)
																					),
																					IntrinsicHeight(
																						child: Container(
																							margin: const EdgeInsets.only( left: 16),
																							width: double.infinity,
																							child: Row(
																								children: [
																									Container(
																										margin: const EdgeInsets.only( right: 12),
																										width: 40,
																										height: 40,
																										child: Image.network(
																											"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/srtrub0f_expires_30_days.png",
																											fit: BoxFit.fill,
																										)
																									),
																									Expanded(
																										child: IntrinsicHeight(
																											child: Container(
																												width: double.infinity,
																												child: Column(
																													crossAxisAlignment: CrossAxisAlignment.start,
																													children: [
																														Text(
																															"Looking for courier",
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
																					Container(
																						margin: const EdgeInsets.only( left: 16),
																						width: 40,
																						height: 12,
																						child: Image.network(
																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/d7p339yk_expires_30_days.png",
																							fit: BoxFit.fill,
																						)
																					),
																				]
																			),
																		),
																	),
																	IntrinsicHeight(
																		child: Container(
																			padding: const EdgeInsets.only( right: 16),
																			margin: const EdgeInsets.only( bottom: 24),
																			width: double.infinity,
																			child: Column(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					Container(
																						margin: const EdgeInsets.only( left: 16),
																						width: 40,
																						height: 12,
																						child: Image.network(
																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/yvnt5b3m_expires_30_days.png",
																							fit: BoxFit.fill,
																						)
																					),
																					IntrinsicHeight(
																						child: Container(
																							margin: const EdgeInsets.only( left: 16),
																							width: double.infinity,
																							child: Row(
																								children: [
																									Container(
																										margin: const EdgeInsets.only( right: 12),
																										width: 40,
																										height: 40,
																										child: Image.network(
																											"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/27etnslv_expires_30_days.png",
																											fit: BoxFit.fill,
																										)
																									),
																									Expanded(
																										child: IntrinsicHeight(
																											child: Container(
																												width: double.infinity,
																												child: Column(
																													crossAxisAlignment: CrossAxisAlignment.start,
																													children: [
																														Text(
																															"Order delivered",
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
															padding: const EdgeInsets.only( top: 28, left: 20, right: 20),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	IntrinsicHeight(
																		child: Container(
																			color: Color(0xFFFFFFFF),
																			margin: const EdgeInsets.only( bottom: 8),
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
																						"\$14.97",
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
																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/fm107ewh_expires_30_days.png",
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
																		padding: const EdgeInsets.only( top: 16, left: 96),
																		child: Column(
																			crossAxisAlignment: CrossAxisAlignment.start,
																			children: [
																				Text(
																					"Cheese Quesadillas",
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
																		width: 64,
																		height: 19,
																		child: Container(
																			decoration: BoxDecoration(
																				borderRadius: BorderRadius.circular(12),
																			),
																			width: 64,
																			height: 19,
																			child: ClipRRect(
																				borderRadius: BorderRadius.circular(12),
																				child: Image.network(
																					"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/ri42kuj1_expires_30_days.png",
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