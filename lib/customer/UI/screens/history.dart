import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdlogistic_v2/core/models/order_model.dart';
import 'package:tdlogistic_v2/customer/bloc/order_bloc.dart';
import 'package:tdlogistic_v2/customer/bloc/order_event.dart';
import 'package:tdlogistic_v2/customer/bloc/order_state.dart';
import 'package:tdlogistic_v2/core/constant.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      // Call API based on the selected tab index
      final status = _getOrderStatusByIndex(_tabController.index);
      // context.read<OrderBlocSearchCus>().add(FetchOrdersByStatus(status));
    }
  }

  String _getOrderStatusByIndex(int index) {
    switch (index) {
      case 0:
        return 'processing';
      case 1:
        return 'shipping';
      case 2:
        return 'delivering';
      case 3:
        return 'cancelled';
      case 4:
        return 'completed';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150),
        child: AppBar(
          elevation: 0,
          backgroundColor: mainColor,
          flexibleSpace: Column(
            children: [
              Container(
                height: 160,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    var baseWidth = 75.0;
                    if (constraints.maxWidth > 600) {
                      baseWidth = constraints.maxWidth / 4;
                    }
                    return Center(
                      child: Container(
                        padding: const EdgeInsets.only(top: 40),
                        child: Image.asset(
                          'lib/assets/logo.png',
                          height: baseWidth,
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  },
                ),
              ),
              TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: Colors.white,
                indicatorWeight: 3,
                labelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                unselectedLabelStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: Colors.black),
                tabs: const [
                  Tab(
                    text: "Đang xử lý",
                  ),
                  Tab(text: "Đang gửi hàng"),
                  Tab(text: "Đang giao hàng"),
                  Tab(text: "Đã hoàn thành"),
                  Tab(text: "Đã huỷ"),
                ],
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: TabBarView(
        controller: _tabController,
        children: const [
          ProcessingOrdersTab(),
          TakingOrdersTab(),
          DeliveringOrdersTab(),
          CancelledOrdersTab(),
          CompletedOrdersTab(),
        ],
      ),
    );
  }
}

class ProcessingOrdersTab extends StatelessWidget {
  const ProcessingOrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProcessingOrderBloc, OrderState>(
      builder: (context, state) {
        if (state is OrderLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is OrderLoaded && state.orders.isNotEmpty) {
          return Column(
            children: [
              Expanded(
                child: OrderListView(orders: state.orders),
              ),
              ElevatedButton(
                onPressed: () {
                  // final newOrder = Order(/* thông tin đơn hàng mới */);
                  context
                      .read<ProcessingOrderBloc>()
                      .add(AddOrder(state.orders, state.page));
                },
                child: const Text('Tải thêm'),
              ),
              const SizedBox(height: 20),
            ],
          );
        } else if (state is OrderError) {
          return Center(child: Text('Lỗi: ${state.error}'));
        }
        return const Center(
          child: Column(
            children: [
              Image(
                image: AssetImage("lib/assets/hoptrong.png"),
              ),
              Text(
                'Chưa có đơn hàng nào',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              )
            ],
          ),
        );
      },
    );
  }
}

class TakingOrdersTab extends StatelessWidget {
  const TakingOrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TakingOrderBloc, OrderState>(
      builder: (context, state) {
        if (state is OrderLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is OrderLoaded && state.orders.isNotEmpty) {
          return Column(children: [
            Expanded(
              child: OrderListView(orders: state.orders),
            ),
            ElevatedButton(
              onPressed: () {
                context
                    .read<TakingOrderBloc>()
                    .add(AddOrder(state.orders, state.page));
              },
              child: const Text('Tải thêm'),
            ),
            const SizedBox(height: 20),
          ]);
        } else if (state is OrderError) {
          return Center(child: Text('Lỗi: ${state.error}'));
        }
        return const Center(
          child: Column(
            children: [
              Image(
                image: AssetImage("lib/assets/hoptrong.png"),
              ),
              Text(
                'Chưa có đơn hàng nào',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              )
            ],
          ),
        );
      },
    );
  }
}

class DeliveringOrdersTab extends StatelessWidget {
  const DeliveringOrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeliveringOrderBloc, OrderState>(
      builder: (context, state) {
        if (state is OrderLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is OrderLoaded && state.orders.isNotEmpty) {
          return Column(children: [
            Expanded(
              child: OrderListView(orders: state.orders),
            ),
            ElevatedButton(
              onPressed: () {
                context
                    .read<DeliveringOrderBloc>()
                    .add(AddOrder(state.orders, state.page));
              },
              child: const Text('Tải thêm'),
            ),
            const SizedBox(height: 20),
          ]);
        } else if (state is OrderError) {
          return Center(child: Text('Lỗi: ${state.error}'));
        }
        return const Center(
          child: Column(
            children: [
              Image(
                image: AssetImage("lib/assets/hoptrong.png"),
              ),
              Text(
                'Chưa có đơn hàng nào',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              )
            ],
          ),
        );
      },
    );
  }
}

class CancelledOrdersTab extends StatelessWidget {
  const CancelledOrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CancelledOrderBloc, OrderState>(
      builder: (context, state) {
        if (state is OrderLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is OrderLoaded && state.orders.isNotEmpty) {
          return Column(children: [
            OrderListView(orders: state.orders),
            ElevatedButton(
              onPressed: () {
                context
                    .read<CancelledOrderBloc>()
                    .add(AddOrder(state.orders, state.page));
              },
              child: const Text('Tải thêm'),
            )
          ]);
        } else if (state is OrderError) {
          return Center(child: Text('Lỗi: ${state.error}'));
        }
        return const Center(
          child: Column(
            children: [
              Image(
                image: AssetImage("lib/assets/hoptrong.png"),
              ),
              Text(
                'Chưa có đơn hàng nào',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              )
            ],
          ),
        );
      },
    );
  }
}

class CompletedOrdersTab extends StatelessWidget {
  const CompletedOrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompletedOrderBloc, OrderState>(
      builder: (context, state) {
        if (state is OrderLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is OrderLoaded && state.orders.isNotEmpty) {
          return Column(children: [
            OrderListView(orders: state.orders),
            ElevatedButton(
              onPressed: () {
                context
                    .read<CompletedOrderBloc>()
                    .add(AddOrder(state.orders, state.page));
              },
              child: const Text('Tải thêm'),
            ),
            const SizedBox(height: 20),
          ]);
        } else if (state is OrderError) {
          return Center(child: Text('Lỗi: ${state.error}'));
        }
        return const Center(
          child: Column(
            children: [
              Image(
                image: AssetImage("lib/assets/hoptrong.png"),
              ),
              Text(
                'Chưa có đơn hàng nào',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              )
            ],
          ),
        );
      },
    );
  }
}

class OrderListView extends StatefulWidget {
  final List<Order> orders;

  const OrderListView({
    super.key,
    required this.orders,
  });

  @override
  State<OrderListView> createState() => _OrderListViewState();
}

class _OrderListViewState extends State<OrderListView> {
  final TextEditingController searchController = TextEditingController();
  String selectedFilter = "name";
  List<Order> filteredOrders = [];

  @override
  void initState() {
    super.initState();
    searchController.addListener(_filterOrders);
    filteredOrders = widget.orders;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterOrders() {
    setState(() {
      filteredOrders = widget.orders.where((order) {
        final searchTerm = searchController.text.toLowerCase();

        if (selectedFilter == 'name') {
          return (order.nameReceiver ?? '').toLowerCase().contains(searchTerm);
        } else if (selectedFilter == 'location') {
          final location =
              '${order.detailDest ?? ''}, ${order.districtDest ?? ''}, ${order.provinceDest ?? ''}';
          return location.toLowerCase().contains(searchTerm);
        } else if (selectedFilter == 'phone') {
          return (order.phoneNumberReceiver ?? '').contains(searchTerm);
        }
        return false;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // DropdownButton để chọn loại lọc
              DropdownButton<String>(
                value: selectedFilter,
                items: const [
                  DropdownMenuItem(value: 'name', child: Text('Lọc theo tên')),
                  DropdownMenuItem(
                      value: 'location', child: Text('Lọc theo địa điểm')),
                  DropdownMenuItem(
                      value: 'phone', child: Text('Lọc theo số điện thoại')),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    selectedFilter = newValue!;
                    _filterOrders(); // Cập nhật danh sách sau khi đổi bộ lọc
                  });
                },
              ),

              const SizedBox(height: 20),

              // TextField để nhập thông tin tìm kiếm
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: _getLabelText(),
                  prefixIcon: const Icon(Icons.search), // Thêm icon tìm kiếm
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredOrders.length,
            itemBuilder: (context, index) {
              final order = filteredOrders[index];
              return ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                leading: CircleAvatar(
                  backgroundColor: Colors.green.withOpacity(0.1),
                  child: const Icon(Icons.local_shipping, color: Colors.green),
                ),
                title: Text(
                  order.trackingNumber ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        const Icon(Icons.person,
                            size: 16.0, color: Colors.grey),
                        const SizedBox(width: 4.0),
                        Text(
                          'Người nhận: ${order.nameReceiver ?? ''}',
                          style: const TextStyle(fontSize: 14.0),
                        )
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        const Icon(Icons.phone, size: 16.0, color: Colors.grey),
                        const SizedBox(width: 4.0),
                        Text(
                          'SĐT: ${order.phoneNumberReceiver ?? ''}',
                          style: const TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 16.0, color: Colors.grey),
                        const SizedBox(width: 4.0),
                        Expanded(
                          child: Text(
                            'Địa chỉ: ${order.detailDest ?? ''}, ${order.districtDest ?? ''}, ${order.provinceDest ?? ''}',
                            style: const TextStyle(fontSize: 14.0),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                tileColor: Colors.white,
                onTap: () {
                  // Xử lý khi người dùng nhấn vào đơn hàng
                  _showOrderDetailsBottomSheet(context, order);
                  context.read<GetImagesBloc>().add(GetOrderImages(order.id!));
                },
              );
            },
          ),
        ),
      ],
    );
  }

  String _getLabelText() {
    switch (selectedFilter) {
      case 'name':
        return 'Tìm kiếm theo tên người nhận';
      case 'location':
        return 'Tìm kiếm theo địa điểm người nhận';
      case 'phone':
        return 'Tìm kiếm theo số điện thoại người nhận';
      default:
        return 'Tìm kiếm';
    }
  }

  void _showOrderDetailsBottomSheet(BuildContext context, Order order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, size: 30),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Chi tiết đơn hàng ${order.trackingNumber ?? ''}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  const Divider(),
                  _buildOrderDetailTile(
                      'Người gửi', order.nameSender, Icons.person),
                  _buildOrderDetailTile(
                      'SĐT người gửi', order.phoneNumberSender, Icons.phone),
                  _buildOrderDetailTile(
                      'Địa chỉ gửi',
                      '${order.provinceSource ?? ''}, ${order.districtSource ?? ''}, ${order.wardSource ?? ''}, ${order.detailSource ?? ''}',
                      Icons.location_on),
                  const Divider(),
                  _buildOrderDetailTile(
                      'Người nhận', order.nameReceiver, Icons.person),
                  _buildOrderDetailTile(
                      'SĐT người nhận', order.phoneNumberReceiver, Icons.phone),
                  _buildOrderDetailTile(
                      'Địa chỉ nhận',
                      '${order.provinceDest ?? ''}, ${order.districtDest ?? ''}, ${order.wardDest ?? ''}, ${order.detailDest ?? ''}',
                      Icons.location_on),
                  const Divider(),
                  _buildOrderDetailTile(
                      'Khối lượng',
                      '${order.mass?.toStringAsFixed(2) ?? ''} kg',
                      Icons.line_weight),
                  _buildOrderDetailTile(
                      'Phí',
                      '${order.fee?.toStringAsFixed(2) ?? ''} VNĐ',
                      Icons.attach_money),
                  _buildOrderDetailTile(
                      'Trạng thái đơn hàng', order.statusCode, Icons.info),

                  const Divider(), // Thêm dòng phân cách trước khi hiển thị hành trình
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Hành trình đơn hàng',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),

                  // Hiển thị hành trình đơn hàng
                  if (order.journies != null)
                    _buildJourneyList(order.journies!),
                  _buildImageSignatureSection(order),
                  _buildCancelSubmitButton(order),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageSignatureSection(Order order) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Hình ảnh và chữ ký',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
          const SizedBox(height: 8), // Khoảng cách giữa tiêu đề và nội dung
          BlocBuilder<GetImagesBloc, OrderState>(
            builder: (context, state) {
              if (state is GettingImages) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is GotImages) {
                final sendImages = state.sendImages;
                final receiveImages = state.receiveImages;
                final sendSignature = state.sendSignature;
                final receiveSignature = state.receiveSignature;

                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hiển thị hình gửi
                      _buildImageGrid("Hình ảnh gửi", sendImages),

                      const SizedBox(height: 16), // Khoảng cách giữa các phần

                      // Hiển thị hình nhận
                      _buildImageGrid("Hình ảnh nhận", receiveImages),

                      const SizedBox(height: 16), // Khoảng cách giữa các phần

                      // Hiển thị chữ ký
                      _buildSignatureSection("Chữ ký người gửi", sendSignature),
                      const SizedBox(height: 8),
                      _buildSignatureSection(
                          "Chữ ký người nhận", receiveSignature),
                    ],
                  ),
                );
              } else if (state is FailedImage) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Lỗi khi lấy hình: ${state.error}",
                    style: const TextStyle(color: mainColor),
                  ),
                );
              }
              return const Text('Không tìm thấy ảnh hoặc chữ ký.');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildImageGrid(String title, List<Uint8List> images) {
    if (images.isEmpty) {
      return Text('$title: Chưa có hình ảnh');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true, // Đảm bảo GridView không chiếm toàn bộ không gian
          physics:
              const NeverScrollableScrollPhysics(), // Tắt cuộn riêng của GridView
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1, // Số cột
            crossAxisSpacing: 8, // Khoảng cách giữa các cột
            mainAxisSpacing: 8, // Khoảng cách giữa các hàng
          ),
          itemCount: images.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Khi nhấn vào ảnh, mở một màn hình mới để phóng to ảnh
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FullScreenImage(image: images[index]),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10), // Bo góc ảnh
                child: Image.memory(
                  images[index],
                  fit: BoxFit.scaleDown,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSignatureSection(String title, Uint8List? signature) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        signature != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.memory(
                  signature,
                  height: 100,
                  fit: BoxFit.contain, // Đảm bảo chữ ký không bị cắt
                ),
              )
            : const Text("Chưa có chữ ký"),
      ],
    );
  }

  Widget _buildOrderDetailTile(String title, String? value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(value ?? 'Chưa có thông tin'),
    );
  }

  Widget _buildJourneyList(List<Journies> journeys) {
    if (journeys.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('Chưa có hành trình nào.'),
      );
    }

    return ListView.builder(
      shrinkWrap: true, // Để ListView nằm gọn trong Modal
      physics:
          const NeverScrollableScrollPhysics(), // Tắt cuộn riêng cho ListView này
      itemCount: journeys.length,
      itemBuilder: (context, index) {
        final journey = journeys[index];
        return _buildJourneyTile(
            journey.message!, DateTime.tryParse(journey.time!));
      },
    );
  }

  Widget _buildJourneyTile(String message, DateTime? timestamp) {
    return ListTile(
      leading: const Icon(Icons.circle, color: Colors.green, size: 15),
      title: Text(message),
      subtitle: Text(
        timestamp != null
            ? '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute}'
            : 'Không rõ thời gian',
      ),
    );
  }

  Widget _buildCancelSubmitButton(Order order) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          order.statusCode != "PROCESSING"
              ? const ElevatedButton(
                  onPressed: null,
                  child: Text(
                    "Từ chối",
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                )
              : ElevatedButton(
                  onPressed: () {
                    _showCancellationDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade200,
                  ),
                  child: const Text(
                    "Từ chối",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
          const SizedBox(width: 8),
          order.statusCode != "DELIVERING"
              ? const ElevatedButton(
                  onPressed: null,
                  child: Text(
                    "Đã nhận",
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                )
              : ElevatedButton(
                  onPressed: () {
                    _showRatingDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade200,
                  ),
                  child: const Text(
                    "Đã nhận",
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ),
        ],
      ),
    );
  }

  void _showCancellationDialog(BuildContext context) {
    String? selectedReason;
    TextEditingController otherReasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text(
            'Lý Do Hủy Đơn Hàng',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: const Text('Không còn nhu cầu'),
                    leading: Radio<String>(
                      value: 'Không còn nhu cầu',
                      groupValue: selectedReason,
                      onChanged: (value) {
                        setState(() {
                          selectedReason = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Sản phẩm không đúng mô tả'),
                    leading: Radio<String>(
                      value: 'Sản phẩm không đúng mô tả',
                      groupValue: selectedReason,
                      onChanged: (value) {
                        setState(() {
                          selectedReason = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Khác'),
                    leading: Radio<String>(
                      value: 'Khác',
                      groupValue: selectedReason,
                      onChanged: (value) {
                        setState(() {
                          selectedReason = value;
                        });
                      },
                    ),
                  ),
                  if (selectedReason == 'Khác')
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TextField(
                        controller: otherReasonController,
                        decoration: InputDecoration(
                          hintText: 'Nhập lý do khác',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                print('Selected Reason: ${selectedReason ?? "Không có"}');
                print('Other Reason: ${otherReasonController.text}');
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
              ),
              child: const Text(
                'Gửi',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey,
              ),
              child: const Text('Hủy'),
            ),
          ],
        );
      },
    );
  }

  void _showRatingDialog(BuildContext context) {
    double rating = 0.0;
    TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Đánh Giá Đơn Hàng'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Phần để chọn rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          color: Colors.yellow,
                        ),
                        onPressed: () {
                          setState(() {
                            rating = index + 1.0;
                          });
                        },
                      );
                    }),
                  ),
                  // Phần để nhập bình luận
                  TextField(
                    controller: commentController,
                    decoration: const InputDecoration(
                      hintText: 'Nhập bình luận của bạn',
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Xử lý khi người dùng nhấn nút Gửi
                print('Rating: $rating');
                print('Comment: ${commentController.text}');
                Navigator.of(context).pop();
              },
              child: const Text('Gửi'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: const Text('Hủy'),
            ),
          ],
        );
      },
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final Uint8List image;

  FullScreenImage({required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Nền đen để làm nổi bật ảnh
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Thanh app trong suốt
        elevation: 0, // Chưa có bóng đổ
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white, size: 40),
          onPressed: () {
            Navigator.of(context).pop(); // Đóng màn hình khi nhấn nút X
          },
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.memory(image), // Hiển thị ảnh toàn màn hình
        ),
      ),
    );
  }
}
