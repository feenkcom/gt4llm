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
	self isReported ifFalse: [ ^ aView empty ].
	^ aView columnedList
		title: 'Context window';
		priority: 10;
		items: [ {'Used tokens' -> usedTokens.
				'Total tokens' -> totalTokens.
				'Remaining tokens' -> self remainingTokens.
				'Usage (%)'
					-> (totalTokens > 0 ifTrue: [ self usagePercentage ] ifFalse: [ nil ])} ];
		column: 'Property' text: #key;
		column: 'Value' text: [ :entry | entry value printString ];
		send: #value
]

{ #category : #testing }
GtLACPContextWindow >> isReported [
	^ usedTokens notNil and: [ totalTokens notNil ]
]

{ #category : #testing }
GtLACPContextWindow >> isValidUpdate: aDictionary [
	^ #('used' 'size')
		allSatisfy: [ :key | 
			| count |
			count := aDictionary at: key ifAbsent: [ nil ].
			count isInteger and: [ count >= 0 ] ]
]

{ #category : #printing }
GtLACPContextWindow >> printOn: aStream [
	self isReported ifFalse: [ ^ aStream nextPutAll: 'Not reported' ].
	aStream
		print: usedTokens;
		nextPutAll: ' / ';
		print: totalTokens;
		nextPutAll: ' tokens'.
	totalTokens = 0 ifTrue: [ ^ self ].
	aStream
		nextPutAll: ' (';
		print: (self usagePercentage roundTo: 0.1);
		nextPutAll: '% used)'
]

{ #category : #accessing }
GtLACPContextWindow >> remainingTokens [
	^ totalTokens - usedTokens max: 0
]

{ #category : #accessing }
GtLACPContextWindow >> totalTokens [
	^ totalTokens
]

{ #category : #updating }
GtLACPContextWindow >> updateFrom: aDictionary [
	(self isValidUpdate: aDictionary) ifFalse: [ ^ self ].
	usedTokens := aDictionary at: 'used'.
	totalTokens := aDictionary at: 'size'
]

{ #category : #accessing }
GtLACPContextWindow >> usagePercentage [
	^ usedTokens / totalTokens * 100.0
]

{ #category : #accessing }
GtLACPContextWindow >> usedTokens [
	^ usedTokens
]
