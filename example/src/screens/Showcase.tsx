import React from 'react'
import { View, StyleSheet } from 'react-native'
import {
  showToast,
  showToastPromise,
  type AlertToastType,
} from 'react-native-nitro-toast'
import FontAwesome6 from '@react-native-vector-icons/fontawesome6'
import { Screen, Card, SectionLabel, ListRow } from '../components/ui'
import { demoFonts, useTheme } from '../theme'

// Fake async work that randomly succeeds or fails.
const fakeUpload = (): Promise<{ message: string }> =>
  new Promise((resolve, reject) => {
    setTimeout(() => {
      if (Math.random() < 0.4) reject(new Error('Upload failed — please retry'))
      else resolve({ message: 'File uploaded successfully!' })
    }, 2200)
  })

const Showcase = () => {
  const t = useTheme()

  const typeAccent: Record<AlertToastType, string> = {
    success: t.success,
    error: t.error,
    warning: t.warning,
    info: t.info,
    loading: t.neutral,
    default: t.neutral,
  }

  const showType = (type: AlertToastType, message: string) =>
    showToast(message, { type, position: 'top', haptics: true })

  const runPromise = () =>
    showToastPromise(
      fakeUpload(),
      {
        loading: 'Uploading your file…',
        success: (r) => r.message,
        error: (e) => (e instanceof Error ? e.message : 'Upload failed'),
      },
      { position: 'top', haptics: true, loading: { title: 'Uploading' } }
    )

  const showCustomIcon = () => {
    const source = FontAwesome6.getImageSourceSync('solid', 'face-smile', 20, '#FFFFFF')
    showToast('A toast with your own icon', {
      title: 'Custom icon',
      position: 'top',
      backgroundColor: '#4169E1',
      titleColor: '#FFFFFF',
      messageColor: '#FFFFFF',
      useOverlay: false,
      haptics: true,
      ...(source?.uri ? { iconUri: source.uri } : null),
    })
  }

  const showCustomFont = (fontFamily: string, label: string) =>
    showToast(`This toast uses the ${label} font`, {
      title: label,
      type: 'info',
      position: 'top',
      fontFamily,
      haptics: true,
    })

  const showStacked = () => {
    const items: { type: AlertToastType; msg: string }[] = [
      { type: 'success', msg: 'Saved to your library' },
      { type: 'info', msg: 'Syncing in the background' },
      { type: 'warning', msg: 'Storage almost full' },
    ]
    items.forEach((it, i) =>
      setTimeout(
        () =>
          showToast(it.msg, {
            type: it.type,
            presentation: 'stacked',
            duration: 0,
          }),
        i * 350
      )
    )
  }

  const showHoldToPause = () =>
    showToast('Press and hold me — the timer pauses while held.', {
      title: 'Hold to pause',
      type: 'info',
      position: 'bottom',
      duration: 4000,
      haptics: true,
    })

  return (
    <Screen>
      <SectionLabel>Toast types</SectionLabel>
      <Card style={{ gap: 0 }}>
        <ListRow
          icon="✅"
          title="Success"
          subtitle="Green, checkmark icon"
          accent={typeAccent.success}
          onPress={() => showType('success', 'Operation completed successfully!')}
        />
        <Divider />
        <ListRow
          icon="⛔️"
          title="Error"
          subtitle="Red, error icon"
          accent={typeAccent.error}
          onPress={() => showType('error', 'Something went wrong.')}
        />
        <Divider />
        <ListRow
          icon="⚠️"
          title="Warning"
          subtitle="Amber, warning icon"
          accent={typeAccent.warning}
          onPress={() => showType('warning', 'Please double-check your input.')}
        />
        <Divider />
        <ListRow
          icon="ℹ️"
          title="Info"
          subtitle="Blue, info icon"
          accent={typeAccent.info}
          onPress={() => showType('info', 'Here is something you should know.')}
        />
      </Card>

      <SectionLabel>Patterns</SectionLabel>
      <Card style={{ gap: 0 }}>
        <ListRow
          icon="⏳"
          title="Promise flow"
          subtitle="loading → success / error, same toast"
          accent={t.primary}
          onPress={runPromise}
        />
        <Divider />
        <ListRow
          icon="🍞"
          title="Stacked deck"
          subtitle="Fire 3 sticky toasts — tap to expand (iOS)"
          accent={t.warning}
          onPress={showStacked}
        />
        <Divider />
        <ListRow
          icon="👆"
          title="Hold to pause"
          subtitle="Press and hold to freeze auto-dismiss"
          accent={t.success}
          onPress={showHoldToPause}
        />
      </Card>

      <SectionLabel>Styling</SectionLabel>
      <Card style={{ gap: 0 }}>
        <ListRow
          icon="🎨"
          title="Custom icon"
          subtitle="Pass any image via iconUri"
          accent="#4169E1"
          onPress={showCustomIcon}
        />
        <Divider />
        <ListRow
          icon="🔤"
          title="Rubik font"
          subtitle="Custom fontFamily"
          accent={t.info}
          onPress={() => showCustomFont(demoFonts.rubik, 'Rubik')}
        />
        <Divider />
        <ListRow
          icon="✍️"
          title="Delius font"
          subtitle="Another custom fontFamily"
          accent={t.success}
          onPress={() => showCustomFont(demoFonts.delius, 'Delius')}
        />
      </Card>
    </Screen>
  )
}

function Divider() {
  const t = useTheme()
  return <View style={[styles.divider, { backgroundColor: t.divider }]} />
}

const styles = StyleSheet.create({
  divider: {
    height: StyleSheet.hairlineWidth,
    marginVertical: 4,
  },
})

export default Showcase
