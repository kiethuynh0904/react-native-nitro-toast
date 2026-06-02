import React from 'react'
import {
  ScrollView,
  View,
  Text,
  Pressable,
  StyleSheet,
  type ViewStyle,
  type StyleProp,
} from 'react-native'
import { useSafeAreaInsets } from 'react-native-safe-area-context'
import { radius, spacing, useTheme } from '../theme'

/** Themed scrollable screen container with safe-area-aware padding. */
export function Screen({ children }: { children: React.ReactNode }) {
  const t = useTheme()
  const insets = useSafeAreaInsets()
  return (
    <ScrollView
      style={{ backgroundColor: t.bg }}
      contentContainerStyle={{
        padding: spacing.lg,
        paddingBottom: insets.bottom + spacing.xl,
        gap: spacing.lg,
      }}
      showsVerticalScrollIndicator={false}
    >
      {children}
    </ScrollView>
  )
}

/** A rounded, bordered surface used to group related content. */
export function Card({
  children,
  style,
}: {
  children: React.ReactNode
  style?: StyleProp<ViewStyle>
}) {
  const t = useTheme()
  return (
    <View
      style={[
        styles.card,
        { backgroundColor: t.card, borderColor: t.cardBorder },
        style,
      ]}
    >
      {children}
    </View>
  )
}

export function SectionLabel({ children }: { children: React.ReactNode }) {
  const t = useTheme()
  return (
    <Text style={[styles.sectionLabel, { color: t.textFaint }]}>
      {String(children).toUpperCase()}
    </Text>
  )
}

export function FieldLabel({ children }: { children: React.ReactNode }) {
  const t = useTheme()
  return <Text style={[styles.fieldLabel, { color: t.textMuted }]}>{children}</Text>
}

/** Generic segmented control. */
export function Segmented<T extends string>({
  value,
  options,
  onChange,
}: {
  value: T
  options: readonly { label: string; value: T }[]
  onChange: (v: T) => void
}) {
  const t = useTheme()
  return (
    <View style={[styles.segment, { backgroundColor: t.controlBg }]}>
      {options.map((opt) => {
        const active = opt.value === value
        return (
          <Pressable
            key={opt.value}
            onPress={() => onChange(opt.value)}
            style={[
              styles.segmentItem,
              active && { backgroundColor: t.card },
            ]}
          >
            <Text
              style={[
                styles.segmentText,
                { color: active ? t.text : t.textMuted },
                active && styles.segmentTextActive,
              ]}
            >
              {opt.label}
            </Text>
          </Pressable>
        )
      })}
    </View>
  )
}

/** A selectable pill. `color` tints the active state. */
export function Chip({
  label,
  active,
  color,
  onPress,
}: {
  label: string
  active: boolean
  color?: string
  onPress: () => void
}) {
  const t = useTheme()
  const tint = color ?? t.primary
  return (
    <Pressable
      onPress={onPress}
      style={[
        styles.chip,
        { borderColor: active ? tint : t.cardBorder, backgroundColor: active ? tint : 'transparent' },
      ]}
    >
      <Text
        style={[
          styles.chipText,
          { color: active ? '#FFFFFF' : t.textMuted },
        ]}
      >
        {label}
      </Text>
    </Pressable>
  )
}

export function Row({
  children,
  style,
}: {
  children: React.ReactNode
  style?: StyleProp<ViewStyle>
}) {
  return <View style={[styles.row, style]}>{children}</View>
}

export function PrimaryButton({
  title,
  onPress,
  color,
}: {
  title: string
  onPress: () => void
  color?: string
}) {
  const t = useTheme()
  return (
    <Pressable
      onPress={onPress}
      style={({ pressed }) => [
        styles.primaryBtn,
        { backgroundColor: color ?? t.primary, opacity: pressed ? 0.85 : 1 },
      ]}
    >
      <Text style={[styles.primaryBtnText, { color: t.primaryText }]}>{title}</Text>
    </Pressable>
  )
}

export function GhostButton({
  title,
  onPress,
}: {
  title: string
  onPress: () => void
}) {
  const t = useTheme()
  return (
    <Pressable
      onPress={onPress}
      style={({ pressed }) => [
        styles.ghostBtn,
        { borderColor: t.cardBorder, opacity: pressed ? 0.6 : 1 },
      ]}
    >
      <Text style={[styles.ghostBtnText, { color: t.textMuted }]}>{title}</Text>
    </Pressable>
  )
}

/** A tappable showcase row with an emoji/icon, title and subtitle. */
export function ListRow({
  icon,
  title,
  subtitle,
  accent,
  onPress,
}: {
  icon: string
  title: string
  subtitle: string
  accent: string
  onPress: () => void
}) {
  const t = useTheme()
  return (
    <Pressable
      onPress={onPress}
      style={({ pressed }) => [styles.listRow, { opacity: pressed ? 0.7 : 1 }]}
    >
      <View style={[styles.listIcon, { backgroundColor: accent + '22' }]}>
        <Text style={{ fontSize: 20 }}>{icon}</Text>
      </View>
      <View style={{ flex: 1 }}>
        <Text style={[styles.listTitle, { color: t.text }]}>{title}</Text>
        <Text style={[styles.listSubtitle, { color: t.textMuted }]}>{subtitle}</Text>
      </View>
      <Text style={[styles.chevron, { color: t.textFaint }]}>›</Text>
    </Pressable>
  )
}

const styles = StyleSheet.create({
  card: {
    borderRadius: radius.lg,
    borderWidth: StyleSheet.hairlineWidth,
    padding: spacing.lg,
    gap: spacing.md,
  },
  sectionLabel: {
    fontSize: 12,
    fontWeight: '700',
    letterSpacing: 0.8,
  },
  fieldLabel: {
    fontSize: 13,
    fontWeight: '600',
    marginBottom: spacing.sm,
  },
  segment: {
    flexDirection: 'row',
    borderRadius: radius.md,
    padding: 3,
    gap: 3,
  },
  segmentItem: {
    flex: 1,
    paddingVertical: 8,
    borderRadius: radius.sm,
    alignItems: 'center',
  },
  segmentText: {
    fontSize: 13,
    fontWeight: '600',
  },
  segmentTextActive: {
    fontWeight: '700',
  },
  chip: {
    paddingHorizontal: 14,
    paddingVertical: 8,
    borderRadius: radius.pill,
    borderWidth: 1,
  },
  chipText: {
    fontSize: 13,
    fontWeight: '600',
  },
  row: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: spacing.sm,
  },
  primaryBtn: {
    borderRadius: radius.md,
    paddingVertical: 15,
    alignItems: 'center',
    justifyContent: 'center',
  },
  primaryBtnText: {
    fontSize: 16,
    fontWeight: '700',
  },
  ghostBtn: {
    borderRadius: radius.md,
    paddingVertical: 13,
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 1,
  },
  ghostBtnText: {
    fontSize: 15,
    fontWeight: '600',
  },
  listRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.md,
    paddingVertical: spacing.sm,
  },
  listIcon: {
    width: 44,
    height: 44,
    borderRadius: radius.md,
    alignItems: 'center',
    justifyContent: 'center',
  },
  listTitle: {
    fontSize: 15,
    fontWeight: '700',
  },
  listSubtitle: {
    fontSize: 13,
    marginTop: 2,
  },
  chevron: {
    fontSize: 24,
    fontWeight: '300',
  },
})
