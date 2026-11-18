"
Agent Client Protocol v1 integration for Glamorous Toolkit. See GtLACPExamples for executable usage.
"
Class {
	#name : #GtLACPCapabilities,
	#superclass : #GtLACPObject,
	#instVars : [
		'data'
	],
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #accessing }
GtLACPCapabilities >> data [
 ^ data
]

{ #category : #accessing }
GtLACPCapabilities >> data: anObject [
 data := anObject
]

{ #category : #views }
GtLACPCapabilities >> gtCapabilitiesFor: aView [
 <gtView>
 ^ aView columnedList title: 'Capabilities'; priority: 0;
  items: [ data keys sorted collect: [ :key | key -> (data at: key) ] ];
  column: 'Capability' text: #key;
  column: 'Advertised value' text: [ :entry | entry value printString ];
  send: #value
]

{ #category : #accessing }
GtLACPCapabilities >> initialize [
 super initialize.
 data := Dictionary new
]

{ #category : #accessing }
GtLACPCapabilities >> supportsLoad [
 ^ data at: 'loadSession' ifAbsent: [ false ]
]

{ #category : #accessing }
GtLACPCapabilities >> supportsPromptType: aString [
 aString = 'text' ifTrue: [ ^ true ].
 ^ (data at: 'promptCapabilities' ifAbsent: [ Dictionary new ])
  at: ({ 'image' -> 'image'. 'audio' -> 'audio'. 'resource' -> 'embeddedContext'. 'resource_link' -> 'embeddedContext' } asDictionary at: aString ifAbsent: [ ^ false ])
  ifAbsent: [ false ]
]

{ #category : #accessing }
GtLACPCapabilities >> supportsResume [
	| sessionCapabilities |
	sessionCapabilities := data at: 'sessionCapabilities' ifAbsent: [ nil ].
	^ sessionCapabilities isDictionary
		and: [ (sessionCapabilities at: 'resume' ifAbsent: [ nil ]) isDictionary ]
]

{ #category : #testing }
GtLACPCapabilities >> supportsSystemPrompt [
	^ self systemPromptCapabilities isDictionary
]

{ #category : #testing }
GtLACPCapabilities >> supportsSystemPromptOverride [
	| promptCapabilities modes |
	promptCapabilities := self systemPromptCapabilities.
	promptCapabilities isDictionary ifFalse: [ ^ false ].
	modes := promptCapabilities at: 'mode' ifAbsent: [ nil ].
	^ modes isDictionary
		and: [ (modes at: 'override' ifAbsent: [ nil ]) isDictionary ]
]

{ #category : #private }
GtLACPCapabilities >> systemPromptCapabilities [
	| sessionCapabilities |
	sessionCapabilities := data at: 'sessionCapabilities' ifAbsent: [ nil ].
	sessionCapabilities isDictionary ifFalse: [ ^ nil ].
	^ sessionCapabilities at: 'systemPrompt' ifAbsent: [ nil ]
]
