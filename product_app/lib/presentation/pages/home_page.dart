import 'package:flutter/material.dart';
import 'product_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),

              // Ícone
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: const Icon(
                  Icons.storefront_outlined,
                  color: Colors.black87,
                  size: 28,
                ),
              ),

              const SizedBox(height: 36),

              // Título
              const Text(
                'Bem-vindo à\nProduct Store',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  height: 1.25,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 12),

              // Subtítulo
              Text(
                'Explore nosso catálogo completo\ncom os melhores produtos.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                  height: 1.6,
                ),
              ),

              const Spacer(),

              // Cards
              Row(
                children: [
                  _InfoCard(
                    icon: Icons.inventory_2_outlined,
                    label: 'Produtos',
                    value: '20+',
                  ),
                  const SizedBox(width: 10),
                  _InfoCard(
                    icon: Icons.grid_view_outlined,
                    label: 'Categorias',
                    value: '4',
                  ),
                  const SizedBox(width: 10),
                  _InfoCard(
                    icon: Icons.star_outline_rounded,
                    label: 'Avaliados',
                    value: '100%',
                  ),
                ],
              ),

              const SizedBox(height: 36),

              // Botão
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProductPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Ver produtos',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded, size: 18),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.grey[600], size: 20),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}
