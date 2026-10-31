"
I describe an agent-owned child conversation and its association with an immediate parent. The child session owns its transcript. I retain reported metadata separately from fresh work state and cancellation authorization.
"
Class {
	#name : #GtLACPSubagent,
	#superclass : #GtLACPObject,
	#instVars : [
		'parentSession',
		'session',
		'data',
		'currentWorkState',
		'currentCapabilities'
	],
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #testing }
GtLACPSubagent >> canCancel [
 ^ session connection state = #ready and: [
  (currentCapabilities at: 'cancel' ifAbsent: [ nil ]) isDictionary and: [
   #(running requires_action) includes: self workState ] ]
]

{ #category : #accessing }
GtLACPSubagent >> data [
 ^ data
]

{ #category : #accessing }
GtLACPSubagent >> description [
 ^ data at: 'description' ifAbsent: [ '' ]
]

{ #category : #accessing }
GtLACPSubagent >> directory [
 ^ data at: 'cwd' ifPresent: [ :path | path asFileReference asAbsolute ]
  ifAbsent: [ parentSession directory ]
]

{ #category : #views }
GtLACPSubagent >> gtAssociationFor: aView [
 <gtView>
 ^ aView columnedList title: 'Subagent'; priority: 0;
  items: [ { 'Title' -> self title. 'Description' -> self description.
   'Parent conversation' -> parentSession. 'Child conversation' -> session.
   'Directory' -> self directory. 'Current work' -> self workState.
   'Can cancel' -> self canCancel. 'Reported metadata' -> data } ];
  column: 'Property' text: #key; column: 'Value' text: [ :entry | entry value printString ]; send: #value;
  actionUpdateButtonTooltip: 'Refresh subagent'
]

{ #category : #initialization }
GtLACPSubagent >> initialize [
 super initialize.
 data := Dictionary new.
 currentCapabilities := Dictionary new
]

{ #category : #updating }
GtLACPSubagent >> invalidateLiveState [
 currentWorkState := nil.
 currentCapabilities := Dictionary new
]

{ #category : #accessing }
GtLACPSubagent >> parentSession [
 ^ parentSession
]

{ #category : #accessing }
GtLACPSubagent >> parentSession: aSession [
 parentSession := aSession
]

{ #category : #accessing }
GtLACPSubagent >> session [
 ^ session
]

{ #category : #accessing }
GtLACPSubagent >> session: aSession [
 session := aSession
]

{ #category : #accessing }
GtLACPSubagent >> title [
 ^ data at: 'title' ifAbsent: [ session remoteSessionId ]
]

{ #category : #updating }
GtLACPSubagent >> updateFrom: aDictionary [
 aDictionary keysAndValuesDo: [ :key :value |
  value ifNil: [ data removeKey: key ifAbsent: [ ] ]
   ifNotNil: [ data at: key put: value deepCopy ] ].
 session isReplaying ifFalse: [
  (aDictionary includesKey: 'capabilities') ifTrue: [
   currentCapabilities := (aDictionary at: 'capabilities') ifNil: [ Dictionary new ] ].
  (aDictionary includesKey: 'state') ifTrue: [
   currentWorkState := aDictionary at: 'state'.
   session applySubagentWorkState: currentWorkState ] ]
]

{ #category : #accessing }
GtLACPSubagent >> workState [
 session state = #closed ifTrue: [ ^ #closed ].
 session connection state = #ready ifFalse: [ ^ #disconnected ].
 ^ currentWorkState ifNil: [ #unconfirmed ]
  ifNotNil: [ (currentWorkState at: 'state' ifAbsent: [ 'unknown' ]) asSymbol ]
]
