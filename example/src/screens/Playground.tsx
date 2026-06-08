import React, { useState } from 'react'
import { View, Text, TextInput, Switch, StyleSheet } from 'react-native'
import {
  showToast,
  dismissToast,
  type AlertToastType,
  type PositionToastType,
  type PresentationToastType,
  type NitroToastConfig,
} from 'react-native-nitro-toast'
import {
  Screen,
  Card,
  FieldLabel,
  Segmented,
  Chip,
  Row,
  PrimaryButton,
  GhostButton,
} from '../components/ui'
import { radius, spacing, useTheme } from '../theme'

const TYPES: readonly AlertToastType[] = [
  'success',
  'error',
  'warning',
  'info',
  'loading',
  'default',
]

const DURATIONS: readonly { label: string; value: number }[] = [
  { label: 'Sticky', value: 0 },
  { label: '2s', value: 2000 },
  { label: '4s', value: 4000 },
  { label: '8s', value: 8000 },
]

const MAX_WIDTHS: readonly { label: string; value?: number }[] = [
  { label: 'Default', value: undefined },
  { label: '320', value: 320 },
  { label: '480', value: 480 },
  { label: '600', value: 600 },
]

const Playground = () => {
  const t = useTheme()

  const SWATCHES: readonly { label: string; value?: string }[] = [
    { label: 'Default', value: undefined },
    { label: 'Indigo', value: '#4F46E5' },
    { label: 'Slate', value: '#334155' },
    { label: 'Rose', value: '#E11D48' },
    { label: 'Emerald', value: '#059669' },
  ]

  const [type, setType] = useState<AlertToastType>('success')
  const [position, setPosition] = useState<PositionToastType>('bottom')
  const [presentation, setPresentation] =
    useState<PresentationToastType>('alert')
  const [duration, setDuration] = useState<number>(4000)
  const [haptics, setHaptics] = useState(true)
  const [useOverlay, setUseOverlay] = useState(true)
  const [bg, setBg] = useState<string | undefined>(undefined)
  const [maxWidth, setMaxWidth] = useState<number | undefined>(undefined)
  const [title, setTitle] = useState('')
  const [message, setMessage] = useState('Your changes have been saved.')
  const [lastId, setLastId] = useState<string | null>(null)

  const show = () => {
    const config: Partial<NitroToastConfig> = {
      type,
      position,
      presentation,
      duration,
      haptics,
      useOverlay,
    }
    if (title.trim().length > 0) config.title = title
    if (bg) {
      config.backgroundColor = bg
      config.titleColor = '#FFFFFF'
      config.messageColor = '#FFFFFF'
    }
    if (maxWidth !== undefined) config.maxWidth = maxWidth
    const id = showToast(message || 'Hello from Nitro Toast', config)
    setLastId(id)
  }

  const dismissLast = () => {
    if (lastId) dismissToast(lastId)
  }

  return (
    <Screen>
      <Card>
        <FieldLabel>Type</FieldLabel>
        <Row>
          {TYPES.map((ty) => (
            <Chip
              key={ty}
              label={ty}
              active={type === ty}
              onPress={() => setType(ty)}
            />
          ))}
        </Row>
      </Card>

      <Card>
        <View>
          <FieldLabel>Position</FieldLabel>
          <Segmented
            value={position}
            onChange={setPosition}
            options={[
              { label: 'Top', value: 'top' },
              { label: 'Bottom', value: 'bottom' },
            ]}
          />
        </View>
        <View>
          <FieldLabel>Presentation</FieldLabel>
          <Segmented
            value={presentation}
            onChange={setPresentation}
            options={[
              { label: 'Alert', value: 'alert' },
              { label: 'Stacked', value: 'stacked' },
            ]}
          />
        </View>
        <View>
          <FieldLabel>Duration</FieldLabel>
          <Row>
            {DURATIONS.map((d) => (
              <Chip
                key={d.label}
                label={d.label}
                active={duration === d.value}
                onPress={() => setDuration(d.value)}
              />
            ))}
          </Row>
        </View>
        <View>
          <FieldLabel>Max width (large screens)</FieldLabel>
          <Row>
            {MAX_WIDTHS.map((m) => (
              <Chip
                key={m.label}
                label={m.label}
                active={maxWidth === m.value}
                onPress={() => setMaxWidth(m.value)}
              />
            ))}
          </Row>
        </View>
      </Card>

      <Card>
        <ToggleRow
          label="Haptics"
          hint="Vibrate when the toast appears"
          value={haptics}
          onValueChange={setHaptics}
        />
        <View style={[styles.divider, { backgroundColor: t.divider }]} />
        <ToggleRow
          label="Overlay"
          hint="Tinted background behind the toast"
          value={useOverlay}
          onValueChange={setUseOverlay}
        />
      </Card>

      <Card>
        <FieldLabel>Background</FieldLabel>
        <Row>
          {SWATCHES.map((s) => (
            <Chip
              key={s.label}
              label={s.label}
              color={s.value}
              active={bg === s.value}
              onPress={() => setBg(s.value)}
            />
          ))}
        </Row>
      </Card>

      <Card>
        <View>
          <FieldLabel>Title (optional)</FieldLabel>
          <Input
            value={title}
            onChangeText={setTitle}
            placeholder="Leave empty for the type default"
          />
        </View>
        <View>
          <FieldLabel>Message</FieldLabel>
          <Input
            value={message}
            onChangeText={setMessage}
            placeholder="Toast message"
          />
        </View>
      </Card>

      <PrimaryButton title="Show toast" onPress={show} />
      <GhostButton title="Dismiss last toast" onPress={dismissLast} />

      <Text style={[styles.footnote, { color: t.textFaint }]}>
        Tip: set Duration to “Sticky”, fire a toast, then dismiss it manually to
        verify the countdown is properly cancelled.
      </Text>
    </Screen>
  )
}

function ToggleRow({
  label,
  hint,
  value,
  onValueChange,
}: {
  label: string
  hint: string
  value: boolean
  onValueChange: (v: boolean) => void
}) {
  const t = useTheme()
  return (
    <View style={styles.toggleRow}>
      <View style={{ flex: 1 }}>
        <Text style={[styles.toggleLabel, { color: t.text }]}>{label}</Text>
        <Text style={[styles.toggleHint, { color: t.textMuted }]}>{hint}</Text>
      </View>
      <Switch value={value} onValueChange={onValueChange} />
    </View>
  )
}

function Input({
  value,
  onChangeText,
  placeholder,
}: {
  value: string
  onChangeText: (v: string) => void
  placeholder: string
}) {
  const t = useTheme()
  return (
    <TextInput
      value={value}
      onChangeText={onChangeText}
      placeholder={placeholder}
      placeholderTextColor={t.textFaint}
      style={[
        styles.input,
        { color: t.text, backgroundColor: t.controlBg, borderColor: t.cardBorder },
      ]}
    />
  )
}

const styles = StyleSheet.create({
  divider: {
    height: StyleSheet.hairlineWidth,
  },
  toggleRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.md,
  },
  toggleLabel: {
    fontSize: 15,
    fontWeight: '600',
  },
  toggleHint: {
    fontSize: 12,
    marginTop: 2,
  },
  input: {
    borderRadius: radius.md,
    borderWidth: StyleSheet.hairlineWidth,
    paddingHorizontal: spacing.md,
    paddingVertical: 12,
    fontSize: 15,
  },
  footnote: {
    fontSize: 12,
    lineHeight: 18,
    textAlign: 'center',
    paddingHorizontal: spacing.sm,
  },
})

export default Playground
