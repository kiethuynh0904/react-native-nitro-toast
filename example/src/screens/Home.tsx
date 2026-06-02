import React from 'react'
import { View, Text, StyleSheet } from 'react-native'
import { useNavigation } from '@react-navigation/native'
import { showToast } from 'react-native-nitro-toast'
import { Screen, Card, ListRow, SectionLabel } from '../components/ui'
import { spacing, useTheme } from '../theme'

const Home = () => {
  const navigation = useNavigation()
  const t = useTheme()

  return (
    <Screen>
      <View style={styles.hero}>
        <Text style={styles.heroEmoji}>🔔</Text>
        <Text style={[styles.heroTitle, { color: t.text }]}>Nitro Toast</Text>
        <Text style={[styles.heroSubtitle, { color: t.textMuted }]}>
          Native toasts, zero bridge — SwiftUI on iOS, Compose on Android.
        </Text>
      </View>

      <SectionLabel>Explore</SectionLabel>
      <Card style={{ gap: 0 }}>
        <ListRow
          icon="🎛️"
          title="Playground"
          subtitle="Tune every option live, then fire a toast"
          accent={t.primary}
          onPress={() => navigation.navigate('Playground')}
        />
        <View style={[styles.divider, { backgroundColor: t.divider }]} />
        <ListRow
          icon="✨"
          title="Showcase"
          subtitle="Curated demos: promise, custom icon, stacked…"
          accent={t.success}
          onPress={() => navigation.navigate('Showcase')}
        />
      </Card>

      <SectionLabel>Tips</SectionLabel>
      <Card>
        <Tip theme={t} icon="👆" text="Press and hold a toast to pause its auto-dismiss — now on both iOS and Android." />
        <Tip theme={t} icon="🌗" text="The app follows your system light/dark appearance." />
        <Tip theme={t} icon="↔️" text="Swipe a toast sideways to dismiss it." />
        <Quick theme={t} />
      </Card>
    </Screen>
  )
}

function Tip({
  theme,
  icon,
  text,
}: {
  theme: ReturnType<typeof useTheme>
  icon: string
  text: string
}) {
  return (
    <View style={styles.tip}>
      <Text style={styles.tipIcon}>{icon}</Text>
      <Text style={[styles.tipText, { color: theme.textMuted }]}>{text}</Text>
    </View>
  )
}

function Quick({ theme }: { theme: ReturnType<typeof useTheme> }) {
  return (
    <Text
      onPress={() =>
        showToast('Welcome to Nitro Toast 👋', {
          type: 'success',
          position: 'top',
          haptics: true,
        })
      }
      style={[styles.quick, { color: theme.primary }]}
    >
      Tap to try a quick toast →
    </Text>
  )
}

const styles = StyleSheet.create({
  hero: {
    alignItems: 'center',
    gap: spacing.xs,
    paddingTop: spacing.lg,
    paddingBottom: spacing.sm,
  },
  heroEmoji: {
    fontSize: 48,
  },
  heroTitle: {
    fontSize: 28,
    fontWeight: '800',
    letterSpacing: -0.5,
  },
  heroSubtitle: {
    fontSize: 14,
    textAlign: 'center',
    lineHeight: 20,
    maxWidth: 320,
  },
  divider: {
    height: StyleSheet.hairlineWidth,
    marginVertical: spacing.xs,
  },
  tip: {
    flexDirection: 'row',
    gap: spacing.md,
    alignItems: 'flex-start',
  },
  tipIcon: {
    fontSize: 16,
    width: 22,
  },
  tipText: {
    flex: 1,
    fontSize: 13,
    lineHeight: 19,
  },
  quick: {
    fontSize: 14,
    fontWeight: '700',
    marginTop: spacing.xs,
  },
})

export default Home
