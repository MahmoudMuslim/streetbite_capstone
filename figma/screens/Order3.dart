import 'package:flutter/material.dart';
class Order3 extends StatefulWidget {
	const Order3({super.key});
	@override
	Order3State createState() => Order3State();
}
class Order3State extends State<Order3> {
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
																						image: NetworkImage("https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/zr24cise_expires_30_days.png"),
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
																												"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/bfvcrdje_expires_30_days.png",
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
																								margin: const EdgeInsets.only( bottom: 3),
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
																													"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/la4ncptc_expires_30_days.png",
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
																																		"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/7fkbyg23_expires_30_days.png",
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
																						IntrinsicWidth(
																							child: IntrinsicHeight(
																								child: Container(
																									margin: const EdgeInsets.only( left: 114),
																									child: Row(
																										crossAxisAlignment: CrossAxisAlignment.start,
																										children: [
																											Container(
																												margin: const EdgeInsets.only( right: 106),
																												width: 40,
																												height: 48,
																												child: Image.network(
																													"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/56iwcif9_expires_30_days.png",
																													fit: BoxFit.fill,
																												)
																											),
																											Container(
																												margin: const EdgeInsets.only( top: 28),
																												width: 40,
																												height: 48,
																												child: Image.network(
																													"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/j6vebtfy_expires_30_days.png",
																													fit: BoxFit.fill,
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
																			"Arrives in 10-15 min",
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
																			padding: const EdgeInsets.only( right: 20),
																			width: double.infinity,
																			child: Column(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					Container(
																						margin: const EdgeInsets.only( left: 20),
																						width: 40,
																						height: 12,
																						child: Image.network(
																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/mznuu3tf_expires_30_days.png",
																							fit: BoxFit.fill,
																						)
																					),
																					IntrinsicHeight(
																						child: Container(
																							margin: const EdgeInsets.only( left: 20),
																							width: double.infinity,
																							child: Row(
																								children: [
																									Container(
																										margin: const EdgeInsets.only( right: 11),
																										width: 39,
																										height: 40,
																										child: Image.network(
																											"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/qwlblims_expires_30_days.png",
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
																						margin: const EdgeInsets.only( left: 20),
																						width: 40,
																						height: 12,
																						child: Image.network(
																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/3osclru1_expires_30_days.png",
																							fit: BoxFit.fill,
																						)
																					),
																				]
																			),
																		),
																	),
																	IntrinsicHeight(
																		child: Container(
																			padding: const EdgeInsets.only( right: 20),
																			width: double.infinity,
																			child: Column(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					Container(
																						margin: const EdgeInsets.only( left: 20),
																						width: 40,
																						height: 12,
																						child: Image.network(
																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/ft3g597y_expires_30_days.png",
																							fit: BoxFit.fill,
																						)
																					),
																					IntrinsicHeight(
																						child: Container(
																							margin: const EdgeInsets.only( left: 20),
																							width: double.infinity,
																							child: Row(
																								children: [
																									Container(
																										margin: const EdgeInsets.only( right: 12),
																										width: 40,
																										height: 40,
																										child: Image.network(
																											"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/10tupidz_expires_30_days.png",
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
																						margin: const EdgeInsets.only( left: 20),
																						width: 40,
																						height: 12,
																						child: Image.network(
																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/e3huh43g_expires_30_days.png",
																							fit: BoxFit.fill,
																						)
																					),
																				]
																			),
																		),
																	),
																	IntrinsicHeight(
																		child: Container(
																			padding: const EdgeInsets.only( right: 20),
																			width: double.infinity,
																			child: Column(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					Container(
																						margin: const EdgeInsets.only( left: 20),
																						width: 40,
																						height: 12,
																						child: Image.network(
																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/ve5wep5j_expires_30_days.png",
																							fit: BoxFit.fill,
																						)
																					),
																					IntrinsicHeight(
																						child: Container(
																							margin: const EdgeInsets.only( left: 20),
																							width: double.infinity,
																							child: Row(
																								children: [
																									Container(
																										margin: const EdgeInsets.only( right: 12),
																										width: 40,
																										height: 40,
																										child: Image.network(
																											"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/kwim6abv_expires_30_days.png",
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
																															"Courier is picking up order",
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
																						margin: const EdgeInsets.only( left: 20),
																						width: 40,
																						height: 12,
																						child: Image.network(
																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/8qwsh5s1_expires_30_days.png",
																							fit: BoxFit.fill,
																						)
																					),
																				]
																			),
																		),
																	),
																	IntrinsicHeight(
																		child: Container(
																			padding: const EdgeInsets.only( right: 20),
																			margin: const EdgeInsets.only( bottom: 24),
																			width: double.infinity,
																			child: Column(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					Container(
																						margin: const EdgeInsets.only( left: 20),
																						width: 40,
																						height: 12,
																						child: Image.network(
																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/siaiu2k2_expires_30_days.png",
																							fit: BoxFit.fill,
																						)
																					),
																					IntrinsicHeight(
																						child: Container(
																							margin: const EdgeInsets.only( left: 20),
																							width: double.infinity,
																							child: Row(
																								children: [
																									Container(
																										margin: const EdgeInsets.only( right: 12),
																										width: 40,
																										height: 40,
																										child: Image.network(
																											"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/ceohq767_expires_30_days.png",
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
															padding: const EdgeInsets.only( top: 28, bottom: 28, left: 20, right: 20),
															width: double.infinity,
															child: Row(
																children: [
																	Container(
																		decoration: BoxDecoration(
																			borderRadius: BorderRadius.circular(112),
																		),
																		margin: const EdgeInsets.only( right: 12),
																		width: 40,
																		height: 40,
																		child: ClipRRect(
																			borderRadius: BorderRadius.circular(112),
																			child: Image.network(
																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/c5neuamx_expires_30_days.png",
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
																						Text(
																							"Vlad S.",
																							style: TextStyle(
																								color: Color(0xFF1C1B1F),
																								fontSize: 28,
																								fontWeight: FontWeight.bold,
																							),
																						),
																						Text(
																							"Contact curier",
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
																	Container(
																		width: 24,
																		height: 24,
																		child: Image.network(
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/2gdnovco_expires_30_days.png",
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
															padding: const EdgeInsets.only( top: 28, left: 20),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	Container(
																		margin: const EdgeInsets.only( bottom: 7),
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