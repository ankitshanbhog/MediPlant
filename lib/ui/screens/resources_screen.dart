import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

class AgriculturalResourcesScreen extends StatelessWidget {
  const AgriculturalResourcesScreen({super.key});

  static const List<_ResourceItem> _resources = [
    _ResourceItem(
      title: 'e-Charak (NMPB Portal)',
      agency: 'National Medicinal Plants Board, Ministry of AYUSH',
      category: 'Farmer & Marketplace Portal',
      description:
          'Online market platform facilitating direct trade of medicinal plants and raw herbs between farmers, nurseries, traders, and pharmaceutical manufacturers without intermediaries.',
      url: 'https://echarak.ayush.gov.in/',
      features: [
        'Live market buy & sell inquiries',
        'Subsidy scheme guidelines for cultivation',
        'Nursery accreditation and quality seed sourcing',
      ],
      tagColor: Color(0xFF2E7D32),
      icon: Icons.storefront_rounded,
      lastVerified: 'November 2026',
    ),
    _ResourceItem(
      title: 'NCCIH Herb Safety & Interactions',
      agency: 'National Center for Complementary & Integrative Health (NIH)',
      category: 'Clinical Safety & Research',
      description:
          'Authoritative medical database detailing clinical trial evidence, safe dosages, known herb–drug interactions, and contraindications for botanical medicine.',
      url: 'https://www.nccih.nih.gov/health/safety',
      features: [
        'Documented herb–drug interaction warnings',
        'Peer-reviewed evidence levels (human clinical trials)',
        'Guidance for pregnancy, pediatrics, and chronic diseases',
      ],
      tagColor: Color(0xFF1565C0),
      icon: Icons.shield_rounded,
      lastVerified: 'November 2026',
    ),
    _ResourceItem(
      title: 'WHO Traditional Medicine Strategy',
      agency: 'World Health Organization (WHO)',
      category: 'Global Standards & Monographs',
      description:
          'International regulatory standards on the safety, efficacy, quality assurance, and sustainable harvesting of traditional and complementary botanical medicines.',
      url: 'https://www.who.int/health-topics/traditional-complementary-and-integrative-medicine',
      features: [
        'WHO monographs on selected medicinal plants',
        'Good Agricultural and Collection Practices (GACP)',
        'Conservation rules for endangered wild flora',
      ],
      tagColor: Color(0xFF00897B),
      icon: Icons.public_rounded,
      lastVerified: 'November 2026',
    ),
    _ResourceItem(
      title: 'CSIR Traditional Knowledge Digital Library (TKDL)',
      agency: 'Council of Scientific & Industrial Research (CSIR)',
      category: 'Pharmacopeia & Taxonomy',
      description:
          'Pioneering digital repository documenting thousands of validated formulations from Ayurveda, Siddha, Unani, and Sowa-Rigpa texts linked to modern scientific literature.',
      url: 'https://www.tkdl.res.in/',
      features: [
        'Scientific classification and binomial nomenclature',
        'Traditional formulations & preparation methods',
        'Bioactive compound profiles and phytochemical data',
      ],
      tagColor: Color(0xFF5E35B1),
      icon: Icons.menu_book_rounded,
      lastVerified: 'November 2026',
    ),
    _ResourceItem(
      title: 'National Horticulture Board (NHB) Schemes',
      agency: 'Ministry of Agriculture & Farmers Welfare',
      category: 'Government Grants & Agronomy',
      description:
          'Credit-linked capital investment subsidy schemes for commercial production, post-harvest management, and polyhouse cultivation of high-value medicinal and aromatic plants.',
      url: 'https://www.nhb.gov.in/',
      features: [
        'Capital subsidy of up to 40% for eligible crop projects',
        'Cold-chain and hygienic drying infrastructure assistance',
        'Soil testing and region-specific agronomy advisory',
      ],
      tagColor: Color(0xFFE65100),
      icon: Icons.agriculture_rounded,
      lastVerified: 'November 2026',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF7FAF8),
      appBar: AppBar(
        title: const Text(
          'Agricultural & Safety Resources',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top informative header
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF1E3A2F), const Color(0xFF132A22)]
                      : [const Color(0xFFE8F5E9), const Color(0xFFC8E6C9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : const Color(0xFFA5D6A7),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.18),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.verified_outlined,
                      color: AppColors.primary,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Verified Institutional Directory',
                          style: TextStyle(
                            fontSize: 16.5,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Traceable government portals, clinical safety registries, and grower subsidy schemes for medicinal flora.',
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.4,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            const Text(
              'Official Portals & References',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tap any resource to copy the verified official URL',
              style: TextStyle(
                fontSize: 13.5,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight,
              ),
            ),
            const SizedBox(height: 16),

            // Directory Cards
            ..._resources.map((item) => _buildResourceCard(context, item, isDark)),

            const SizedBox(height: 18),
            // Regulatory disclaimer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : const Color(0xFFE2EBE5),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.gavel_rounded, size: 20, color: Colors.blueGrey),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Resource listings are provided for reference only. MediPlant does not endorse commercial transactions or provide legal representation for government agricultural grant disbursements.',
                      style: TextStyle(
                        fontSize: 12.5,
                        height: 1.45,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceCard(BuildContext context, _ResourceItem item, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.borderDark : const Color(0xFFE5ECE7),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: item.tagColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item.icon, color: item.tagColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: item.tagColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item.category.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          color: item.tagColor,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.3,
                      ),
                    ),
                    Text(
                      item.agency,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          Text(
            item.description,
            style: TextStyle(
              fontSize: 14.5,
              height: 1.5,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 14),

          // Highlights
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceSubtleDark : const Color(0xFFF7FAF8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: item.features.map((f) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.check_circle_outline_rounded,
                          size: 15, color: item.tagColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          f,
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.35,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textPrimaryLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 14),

          // URL row and copy action
          InkWell(
            onTap: () {
              Clipboard.setData(ClipboardData(text: item.url));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Copied ${item.title} portal link to clipboard.'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: item.tagColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: item.tagColor.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.link_rounded, size: 16, color: item.tagColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item.url,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: item.tagColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.copy_rounded, size: 14, color: Colors.grey),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Verified: ${item.lastVerified}',
              style: TextStyle(
                fontSize: 11,
                fontStyle: FontStyle.italic,
                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResourceItem {
  final String title;
  final String agency;
  final String category;
  final String description;
  final String url;
  final List<String> features;
  final Color tagColor;
  final IconData icon;
  final String lastVerified;

  const _ResourceItem({
    required this.title,
    required this.agency,
    required this.category,
    required this.description,
    required this.url,
    required this.features,
    required this.tagColor,
    required this.icon,
    required this.lastVerified,
  });
}

