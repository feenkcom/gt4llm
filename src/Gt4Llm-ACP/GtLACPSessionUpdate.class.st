"
I retain a raw session update and its reception timestamp. My contextUsageUpdate references the latest valid raw usage notification known before I arrived. This evidence supports historical context derivation without stored interpreted context windows.
"
Class {
	#name : #GtLACPSessionUpdate,
	#superclass : #GtLACPObject,
	#instVars : [
		'data',
		'timestamp',
		'contextUsageUpdate'
	],
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #accessing }
GtLACPSessionUpdate >> contextUsageUpdate [
	^ contextUsageUpdate
]

{ #category : #accessing }
GtLACPSessionUpdate >> contextUsageUpdate: anUpdate [
	contextUsageUpdate := anUpdate
]

{ #category : #accessing }
GtLACPSessionUpdate >> contextWindow [
	^ GtLACPContextWindow new
		updateFrom: data;
		yourself
]

{ #category : #accessing }
GtLACPSessionUpdate >> data [
 ^ data
]

{ #category : #accessing }
GtLACPSessionUpdate >> data: anObject [
 data := anObject
]

{ #category : #views }
GtLACPSessionUpdate >> gtUpdateFor: aView [
 <gtView>
 ^ aView textEditor title: 'Update'; priority: 20; text: [ STONJSON toStringPretty: data ]; actionUpdateButtonTooltip: 'Refresh update'
]

{ #category : #accessing }
GtLACPSessionUpdate >> isValidContextUsage [
	^ self kind = 'usage_update'
		and: [ #('used' 'size')
				allSatisfy: [ :key | 
					| count |
					count := data at: key ifAbsent: [ nil ].
					count isInteger and: [ count >= 0 ] ] ]
]

{ #category : #accessing }
GtLACPSessionUpdate >> kind [
 ^ data at: 'sessionUpdate'
]

{ #category : #accessing }
GtLACPSessionUpdate >> timestamp [
 ^ timestamp
]

{ #category : #accessing }
GtLACPSessionUpdate >> timestamp: anObject [
 timestamp := anObject
]
