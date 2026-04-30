Class {
	#name : #GtLMagritteToolForMotd,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#instVars : [
		'motd'
	],
	#category : 'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLMagritteToolForMotd >> description [
	^ 'Answer''s GT Message Of The Day'
]

{ #category : #accessing }
GtLMagritteToolForMotd >> motd [
	^ motd ifNil: [ 'Hi! From GT' ]
]

{ #category : #accessing }
GtLMagritteToolForMotd >> motd: anObject [
	motd := anObject
]

{ #category : #accessing }
GtLMagritteToolForMotd >> name [
	^ 'gtMotd'
]

{ #category : #execution }
GtLMagritteToolForMotd >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	"Answer the motd text.
	This is mostly for testing.  If arguments are supplied, include them in the message."
	| arguments result |

	arguments := aToolCall arguments ifNil: [ Dictionary new ].

	result := GtLString forString: (arguments
		ifEmpty: [ self motd ]
		ifNotEmpty: [ self motd, ', with ', arguments storeString ]).
	^ result.
]
