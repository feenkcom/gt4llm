"
I capture the latest context-window token counts reported by an ACP session. I describe current occupancy, not cumulative token consumption or a monetary budget.
"
Class {
	#name : #GtLACPContextWindow,
	#superclass : #GtLACPObject,
	#instVars : [
		'usedTokens',
		'totalTokens'
	],
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #'gt-views' }
GtLACPContextWindow >> gtContextWindowFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Context window';
		priority: 10;
		items: [ {'Used tokens' -> usedTokens.
				'Total tokens' -> totalTokens.
				'Remaining tokens' -> self remainingTokens.
				'Usage (%)' -> self usagePercentage} ];
		column: 'Property' text: #key;
		column: 'Value' text: [ :entry | entry value printString ];
		send: #value
]

{ #category : #initialization }
GtLACPContextWindow >> initializeFrom: aDictionary [
	usedTokens := aDictionary at: 'used'.
	totalTokens := aDictionary at: 'size'
]

{ #category : #printing }
GtLACPContextWindow >> printOn: aStream [
	aStream
		print: usedTokens;
		nextPutAll: ' / ';
		print: totalTokens;
		nextPutAll: ' tokens'.
	self usagePercentage
		ifNotNil: [ :percentage | 
			aStream
				nextPutAll: ' (';
				print: (percentage roundTo: 0.1);
				nextPutAll: '% used)' ]
]

{ #category : #accessing }
GtLACPContextWindow >> remainingTokens [
	^ totalTokens - usedTokens max: 0
]

{ #category : #accessing }
GtLACPContextWindow >> totalTokens [
	^ totalTokens
]

{ #category : #accessing }
GtLACPContextWindow >> usagePercentage [
	totalTokens = 0 ifTrue: [ ^ nil ].
	^ ((usedTokens / totalTokens) * 100) roundTo: 0.1
]

{ #category : #accessing }
GtLACPContextWindow >> usedTokens [
	^ usedTokens
]
