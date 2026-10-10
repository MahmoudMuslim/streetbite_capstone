import 'package:flutter/material.dart';
class Checkout extends StatefulWidget {
	const Checkout({super.key});
	@override
	CheckoutState createState() => CheckoutState();
}
class CheckoutState extends State<Checkout> {
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
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/ruax2mfg_expires_30_days.png",
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
																mainAxisAlignment: MainAxisAlignment.spaceBetween,
																children: [
																	Container(
																		width: 24,
																		height: 24,
																		child: Image.network(
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/8swnqrxf_expires_30_days.png",
																			fit: BoxFit.fill,
																		)
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
																	Text(
																		"Checkout",
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
															padding: const EdgeInsets.only( top: 16, bottom: 16, left: 20, right: 20),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	IntrinsicHeight(
																		child: Container(
																			padding: const EdgeInsets.symmetric(vertical: 34),
																			width: double.infinity,
																			decoration: BoxDecoration(
																				borderRadius: BorderRadius.circular(12),
																				image: DecorationImage(
																					image: NetworkImage("https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/h4zm4aj8_expires_30_days.png"),
																					fit: BoxFit.fill
																				),
																			),
																			child: Column(
																				children: [
																					Container(
																						margin: const EdgeInsets.only( bottom: 8),
																						width: 40,
																						height: 48,
																						child: Image.network(
																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/i5icgn1o_expires_30_days.png",
																							fit: BoxFit.fill,
																						)
																					),
																					InkWell(
																						onTap: () { print('Pressed'); },
																						child: IntrinsicWidth(
																							child: IntrinsicHeight(
																								child: Container(
																									decoration: BoxDecoration(
																										borderRadius: BorderRadius.circular(32),
																										color: Color(0xFFFFFFFF),
																										boxShadow: [
																											BoxShadow(
																												color: Color(0x26000000),
																												blurRadius: 8,
																												offset: Offset(0, 4),
																											),
																										],
																									),
																									padding: const EdgeInsets.only( top: 4, bottom: 4, left: 12, right: 12),
																									child: Column(
																										crossAxisAlignment: CrossAxisAlignment.start,
																										children: [
																											Text(
																												"Adjust pin",
																												style: TextStyle(
																													color: Color(0xFF1C1B1F),
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
															padding: const EdgeInsets.only( top: 12, bottom: 12, left: 16, right: 16),
															width: double.infinity,
															child: Row(
																children: [
																	Container(
																		margin: const EdgeInsets.only( right: 12),
																		width: 24,
																		height: 24,
																		child: Image.network(
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/oxvsmhfn_expires_30_days.png",
																			fit: BoxFit.fill,
																		)
																	),
																	Expanded(
																		child: IntrinsicHeight(
																			child: Container(
																				width: double.infinity,
																				child: Row(
																					mainAxisAlignment: MainAxisAlignment.spaceBetween,
																					children: [
																						Text(
																							"Delivery Time",
																							style: TextStyle(
																								color: Color(0xFF1C1B1F),
																								fontSize: 16,
																								fontWeight: FontWeight.bold,
																							),
																						),
																						Text(
																							"20-25 min",
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
																]
															),
														),
													),
													IntrinsicWidth(
														child: IntrinsicHeight(
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
																						decoration: BoxDecoration(
																							border: Border.all(
																								color: Color(0xFFF7F7F7),
																								width: 2,
																							),
																							borderRadius: BorderRadius.circular(12),
																							color: Color(0xFFFFFFFF),
																						),
																						padding: const EdgeInsets.only( top: 14, bottom: 14, left: 16, right: 16),
																						margin: const EdgeInsets.only( right: 8),
																						child: Column(
																							crossAxisAlignment: CrossAxisAlignment.start,
																							children: [
																								IntrinsicWidth(
																									child: IntrinsicHeight(
																										child: Row(
																											children: [
																												Container(
																													margin: const EdgeInsets.only( right: 51),
																													child: Text(
																														"Express",
																														style: TextStyle(
																															color: Color(0xFF1C1B1F),
																															fontSize: 16,
																															fontWeight: FontWeight.bold,
																														),
																													),
																												),
																												Container(
																													width: 24,
																													height: 24,
																													child: Image.network(
																														"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/hexeh41p_expires_30_days.png",
																														fit: BoxFit.fill,
																													)
																												),
																											]
																										),
																									),
																								),
																								Container(
																									margin: const EdgeInsets.only( bottom: 4),
																									child: Text(
																										"10-15 min",
																										style: TextStyle(
																											color: Color(0xFF1C1B1F),
																											fontSize: 14,
																										),
																									),
																								),
																								Text(
																									"+ \$2.99",
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
																							border: Border.all(
																								color: Color(0xFF00C773),
																								width: 2,
																							),
																							borderRadius: BorderRadius.circular(12),
																							color: Color(0xFFFFFFFF),
																						),
																						padding: const EdgeInsets.only( top: 12, left: 16, right: 16),
																						margin: const EdgeInsets.only( right: 8),
																						child: Column(
																							crossAxisAlignment: CrossAxisAlignment.start,
																							children: [
																								IntrinsicWidth(
																									child: IntrinsicHeight(
																										child: Row(
																											children: [
																												Container(
																													margin: const EdgeInsets.only( right: 41),
																													child: Text(
																														"Standard",
																														style: TextStyle(
																															color: Color(0xFF1C1B1F),
																															fontSize: 16,
																															fontWeight: FontWeight.bold,
																														),
																													),
																												),
																												Container(
																													width: 24,
																													height: 24,
																													child: Image.network(
																														"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/347uqe1q_expires_30_days.png",
																														fit: BoxFit.fill,
																													)
																												),
																											]
																										),
																									),
																								),
																								Container(
																									margin: const EdgeInsets.only( bottom: 44),
																									child: Text(
																										"20-25 min",
																										style: TextStyle(
																											color: Color(0xFF1C1B1F),
																											fontSize: 14,
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
																						decoration: BoxDecoration(
																							border: Border.all(
																								color: Color(0xFFF7F7F7),
																								width: 2,
																							),
																							borderRadius: BorderRadius.circular(12),
																							color: Color(0xFFFFFFFF),
																						),
																						padding: const EdgeInsets.only( top: 14, bottom: 14, left: 16, right: 16),
																						margin: const EdgeInsets.only( right: 8),
																						child: Column(
																							crossAxisAlignment: CrossAxisAlignment.start,
																							children: [
																								IntrinsicWidth(
																									child: IntrinsicHeight(
																										child: Row(
																											children: [
																												Container(
																													margin: const EdgeInsets.only( right: 51),
																													child: Text(
																														"Express",
																														style: TextStyle(
																															color: Color(0xFF1C1B1F),
																															fontSize: 16,
																															fontWeight: FontWeight.bold,
																														),
																													),
																												),
																												Container(
																													width: 24,
																													height: 24,
																													child: Image.network(
																														"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/hexeh41p_expires_30_days.png",
																														fit: BoxFit.fill,
																													)
																												),
																											]
																										),
																									),
																								),
																								Container(
																									margin: const EdgeInsets.only( bottom: 4),
																									child: Text(
																										"10-15 min",
																										style: TextStyle(
																											color: Color(0xFF1C1B1F),
																											fontSize: 14,
																										),
																									),
																								),
																								Text(
																									"+ \$2.99",
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
																		],
																	)
																),
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															padding: const EdgeInsets.all(16),
															width: double.infinity,
															child: Row(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	Container(
																		margin: const EdgeInsets.only( right: 12),
																		width: 24,
																		height: 24,
																		child: Image.network(
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/pspwyx7h_expires_30_days.png",
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
																						Container(
																							margin: const EdgeInsets.only( bottom: 4),
																							child: Text(
																								"Park Way 145",
																								style: TextStyle(
																									color: Color(0xFF1C1B1F),
																									fontSize: 16,
																									fontWeight: FontWeight.bold,
																								),
																							),
																						),
																						Text(
																							"Main entrance",
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
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															padding: const EdgeInsets.all(16),
															width: double.infinity,
															child: Row(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	Container(
																		margin: const EdgeInsets.only( right: 12),
																		width: 24,
																		height: 24,
																		child: Image.network(
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/z3bufz5w_expires_30_days.png",
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
																						Container(
																							margin: const EdgeInsets.only( bottom: 4),
																							child: Text(
																								"Leave it at my door",
																								style: TextStyle(
																									color: Color(0xFF1C1B1F),
																									fontSize: 16,
																									fontWeight: FontWeight.bold,
																								),
																							),
																						),
																						Text(
																							"Add more details",
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
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															padding: const EdgeInsets.symmetric(vertical: 16),
															width: double.infinity,
															child: Row(
																children: [
																	Container(
																		margin: const EdgeInsets.only( left: 16, right: 12),
																		width: 24,
																		height: 24,
																		child: Image.network(
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/bb1isd2t_expires_30_days.png",
																			fit: BoxFit.fill,
																		)
																	),
																	Text(
																		"(628) 222-1133",
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
													IntrinsicHeight(
														child: Container(
															padding: const EdgeInsets.symmetric(vertical: 16),
															margin: const EdgeInsets.only( bottom: 47),
															width: double.infinity,
															child: Row(
																children: [
																	Container(
																		margin: const EdgeInsets.only( left: 16, right: 12),
																		width: 24,
																		height: 24,
																		child: Image.network(
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/nhckf6d6_expires_30_days.png",
																			fit: BoxFit.fill,
																		)
																	),
																	Text(
																		"Add promo",
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
																							"Place order",
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