import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:restapi_0029/logic/bloc/auth/auth_bloc.dart';
import 'package:restapi_0029/logic/bloc/auth/auth_event.dart';
import 'package:restapi_0029/logic/bloc/hewan/hewan_bloc.dart';
import 'package:restapi_0029/logic/bloc/hewan/hewan_event.dart';
import 'package:restapi_0029/logic/bloc/hewan/hewan_state.dart';
import 'package:restapi_0029/ui/pages/add_hewan_page.dart';
import 'package:restapi_0029/ui/pages/edit_hewan_page.dart';
import '../../data/repositories/hewan_repository.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          HewanBloc(repository: HewanRepository())..add(FetchHewan()),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text(
            "🌾 Koleksi Ternak",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: Color(0xFF2E7D32),
          elevation: 2,
          actions: [
            IconButton(
              onPressed: () => context.read<AuthBloc>().add(LogoutRequested()),
              icon: const Icon(Icons.logout, color: Colors.white),
              tooltip: 'Logout',
            ),
          ],
        ),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF2E7D32), Color(0xFF558B2F)],
                ),
              ),
            ),
            BlocListener<HewanBloc, HewanState>(
              listener: (context, state) {
                if (state is HewanCreatedSuccess) {
                  _showSnackBar(context, "Operasi Berhasil!", Colors.green);
                } else if (state is HewanError) {
                  _showSnackBar(context, state.message, Colors.red);
                }
              },
              child: BlocBuilder<HewanBloc, HewanState>(
                builder: (context, state) {
                  if (state is HewanLoading) {
                    return Center(
                      child: Lottie.asset('assets/loading.json', width: 200),
                    );
                  } else if (state is HewanLoaded) {
                    if (state.hewanList.isEmpty) {
                      return const Center(
                        child: Text(
                          "Belum ada koleksi.",
                          style: TextStyle(color: Colors.white70),
                        ),
                      );
                    }
                    return CustomRefreshIndicator(
                      onRefresh: () async {
                        context.read<HewanBloc>().add(FetchHewan());
                        await Future.delayed(const Duration(seconds: 2));
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 100, 16, 100),
                        itemCount: state.hewanList.length,
                        itemBuilder: (context, index) {
                          final hewan = state.hewanList[index];
                          return _buildGlassCard(context, hewan);
                        },
                      ),
                      builder: (context, child, controller) {
                        return AnimatedBuilder(
                          animation: controller,
                          builder: (context, _) {
                            return Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                if (!controller.isIdle)
                                  Positioned(
                                    top: 50 * controller.value,
                                    child: Lottie.asset(
                                      'assets/loading.json',
                                      height: 80,
                                    ),
                                  ),
                                Transform.translate(
                                  offset: Offset(0, 100.0 * controller.value),
                                  child: child,
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  }
                  return const Center(child: Text("Gagal memuat data."));
                },
              ),
            ),
          ],
        ),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (innerContext) => BlocProvider.value(
                    value: context.read<HewanBloc>(),
                    child: const AddHewanPage(),
                  ),
                ),
              );
            },
            backgroundColor: Color(0xFF8D6E63),
            elevation: 4,
            child: const Icon(Icons.add, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassCard(BuildContext context, dynamic hewan) {
    final animalIcon = _getAnimalIcon(hewan.jenis);
    final priceText = "Rp ${_formatPrice(hewan.harga)}";
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFFFA726).withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Color(0xFF8D6E63).withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color(0xFF8D6E63).withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          animalIcon,
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hewan.nama,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              hewan.jenis,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Color(0xFFFFA726)),
                        onPressed: () => _showDeleteDialog(context, hewan),
                        constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Tanggal Lahir",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 11,
                              ),
                            ),
                            Text(
                              hewan.tanggalLahir,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Status",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 11,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Color(0xFF4CAF50).withOpacity(0.5),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                hewan.status,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Color(0xFF8D6E63).withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          priceText,
                          style: const TextStyle(
                            color: Color(0xFFFFA726),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            final bloc = context.read<HewanBloc>();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (innerContext) => BlocProvider.value(
                                  value: bloc,
                                  child: EditHewanPage(hewan: hewan),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Color(0xFF4CAF50),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              "Edit",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getAnimalIcon(String jenis) {
    final jenisLower = jenis.toLowerCase();
    if (jenisLower.contains('sapi') || jenisLower.contains('cow')) return '🐄';
    if (jenisLower.contains('kambing') || jenisLower.contains('goat')) return '🐐';
    if (jenisLower.contains('domba') || jenisLower.contains('sheep')) return '🐑';
    if (jenisLower.contains('babi') || jenisLower.contains('pig')) return '🐷';
    if (jenisLower.contains('ayam') || jenisLower.contains('chicken')) return '🐔';
    if (jenisLower.contains('kuda') || jenisLower.contains('horse')) return '🐴';
    if (jenisLower.contains('angsa') || jenisLower.contains('duck')) return '🦆';
    return '🐾';
  }

  String _formatPrice(int price) {
    if (price >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(1)}JT';
    } else if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(0)}K';
    }
    return price.toString();
  }

  void _showDeleteDialog(BuildContext context, dynamic hewan) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Color(0xFF2E7D32),
        title: const Text("Hapus Data?", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text(
          "Yakin ingin menghapus '${hewan.nama}'?",
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Batal", style: TextStyle(color: Color(0xFFFFA726))),
          ),
          TextButton(
            onPressed: () {
              context.read<HewanBloc>().add(DeleteHewan(hewan.id));
              Navigator.pop(dialogContext);
            },
            child: const Text(
              "Hapus",
              style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String msg, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }
}