Class {
	#name : #GtLlmDurationPrinter,
	#superclass : #Object,
	#category : #'Gt4Llm-Widgets'
}

{ #category : #printing }
GtLlmDurationPrinter >> printDuration: aDuration on: aStream [
	aDuration < 0 seconds
		ifTrue: [ aStream nextPut: $-.
			self printDuration: aDuration negated on: aStream.
			^ self ].

	aDuration < 15 seconds
		ifTrue: [ aStream nextPutAll: 'just now'.
			^ self ].
	aDuration < 1 minute
		ifTrue: [ aStream nextPutAll: 'less than minute ago'.
			^ self ].
	aDuration < 1 hour
		ifTrue: [ ^ self
				printNumber: aDuration minutes
				unit: 'minute'
				on: aStream ].
	aDuration < 1 day
		ifTrue: [ ^ self
				printNumber: aDuration hours
				unit: 'hour'
				on: aStream ].
	aDuration < 30 days
		ifTrue: [ ^ self
				printNumber: aDuration days
				unit: 'day'
				on: aStream ].
	aDuration < 1 year
		ifTrue: [ ^ self
				printNumber: aDuration days // 30
				unit: 'day'
				on: aStream ].
	^ self
		printNumber: aDuration // 1 year
		unit: 'year'
		on: aStream
]

{ #category : #printing }
GtLlmDurationPrinter >> printNumber: aNumber unit: aString on: aStream [
	aStream nextPutAll: aNumber asString.
	aStream space.
	aStream nextPutAll: (aString asPluralBasedOn: aNumber).
	aStream nextPutAll: ' ago'
]

{ #category : #converting }
GtLlmDurationPrinter >> value: aDuration [
	^ String streamContents: [ :aStream | 
		self printDuration: aDuration on: aStream ]
]
