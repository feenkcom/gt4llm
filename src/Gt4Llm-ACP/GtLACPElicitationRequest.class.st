"
I retain an ACP form elicitation and its draft answers independently of chat elements. I validate supported fields, settle once, and distinguish acceptance, decline, cancellation and transport abandonment.
"
Class {
	#name : #GtLACPElicitationRequest,
	#superclass : #GtLACPObject,
	#instVars : [
		'session',
		'turn',
		'requestId',
		'data',
		'answers',
		'state',
		'lock',
		'toolCall'
	],
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #actions }
GtLACPElicitationRequest >> abandon [
	| changed |
	changed := lock
			critical: [ state = #pending
					ifTrue: [ state := #cancel.
						true ]
					ifFalse: [ false ] ].
	changed ifTrue: [ session announceMessageChanged: turn assistantMessage ]
]

{ #category : #accessing }
GtLACPElicitationRequest >> answerAt: aKey [
	^ answers at: aKey ifAbsent: [ nil ]
]

{ #category : #accessing }
GtLACPElicitationRequest >> answerAt: aKey put: aValue [
	lock
		critical: [ state = #pending
				ifFalse: [ self error: 'This question has already been resolved' ].
			(self fields includesKey: aKey)
				ifFalse: [ self error: 'Unknown question field' ].
			aValue
				ifNil: [ answers removeKey: aKey ifAbsent: [  ] ]
				ifNotNil: [ answers at: aKey put: aValue ] ]
]

{ #category : #accessing }
GtLACPElicitationRequest >> answers [
	^ answers copy
]

{ #category : #converting }
GtLACPElicitationRequest >> asElement [
	^ GtLACPElicitationElement new
		elicitation: self;
		yourself
]

{ #category : #actions }
GtLACPElicitationRequest >> cancel [
	self resolveAction: 'cancel'
]

{ #category : #accessing }
GtLACPElicitationRequest >> data [
	^ data
]

{ #category : #accessing }
GtLACPElicitationRequest >> data: anObject [
	data := anObject
]

{ #category : #actions }
GtLACPElicitationRequest >> decline [
	self resolveAction: 'decline'
]

{ #category : #accessing }
GtLACPElicitationRequest >> fields [
	| properties |
	properties := (self schema at: 'properties' ifAbsent: [ nil ])
			ifNil: [ Dictionary new ].
	^ (properties associations sorted: [ :a :b | a key < b key ])
		asOrderedDictionary
]

{ #category : #views }
GtLACPElicitationRequest >> gtFormFor: aView [
	<gtView>
	^ aView explicit
		title: 'Questions';
		priority: 0;
		stencil: [ self asElement ]
]

{ #category : #validation }
GtLACPElicitationRequest >> hasSupportedFields [
	(data at: 'mode' ifAbsent: [ 'form' ]) = 'form' ifFalse: [ ^ false ].
	(self schema at: 'type' ifAbsent: [ 'object' ]) = 'object' ifFalse: [ ^ false ].
	^ self fields values
		allSatisfy: [ :field | 
			(#('string' 'number' 'integer' 'boolean')
				includes: (field at: 'type' ifAbsent: [ '' ]))
				or: [ (field at: 'type' ifAbsent: [ '' ]) = 'array'
						and: [ (self optionsFor: field) notEmpty ] ] ]
]

{ #category : #initialization }
GtLACPElicitationRequest >> initialize [
	super initialize.
	data := Dictionary new.
	answers := Dictionary new.
	state := #pending.
	lock := Mutex new
]

{ #category : #validation }
GtLACPElicitationRequest >> isSupported [
	^ [ self hasSupportedFields ] on: Error do: [ :ex | false ]
]

{ #category : #accessing }
GtLACPElicitationRequest >> message [
	^ data at: 'message' ifAbsent: [ 'Your input is needed' ]
]

{ #category : #accessing }
GtLACPElicitationRequest >> optionsFor: aField [
	| items |
	(aField includesKey: 'oneOf') ifTrue: [ ^ aField at: 'oneOf' ].
	(aField includesKey: 'enum')
		ifTrue: [ ^ (aField at: 'enum')
				collect: [ :value | 
					{'const' -> value.
						'title' -> value asString} asDictionary ] ].
	items := aField at: 'items' ifAbsent: [ Dictionary new ].
	^ items
		at: 'anyOf'
		ifAbsent: [ (items at: 'enum' ifAbsent: [ #() ])
				collect: [ :value | 
					{'const' -> value.
						'title' -> value asString} asDictionary ] ]
]

{ #category : #printing }
GtLACPElicitationRequest >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPutAll: ' (';
		nextPutAll: state asString;
		nextPutAll: ') ';
		nextPutAll: self message
]

{ #category : #accessing }
GtLACPElicitationRequest >> requestId [
	^ requestId
]

{ #category : #accessing }
GtLACPElicitationRequest >> requestId: anObject [
	requestId := anObject
]

{ #category : #actions }
GtLACPElicitationRequest >> resolveAction: anAction [
	| changed |
	changed := lock
			critical: [ state = #pending
					ifTrue: [ anAction = 'accept' ifTrue: [ self validateAnswers ].
						state := anAction asSymbol.
						session connection
							replyTo: requestId
							result: (anAction = 'accept'
									ifTrue: [ {'action' -> anAction.
											'content' -> answers copy} asDictionary ]
									ifFalse: [ {'action' -> anAction} asDictionary ]).
						true ]
					ifFalse: [ false ] ].
	changed ifTrue: [ session announceMessageChanged: turn assistantMessage ]
]

{ #category : #accessing }
GtLACPElicitationRequest >> schema [
	^ data at: 'requestedSchema' ifAbsent: [ Dictionary new ]
]

{ #category : #accessing }
GtLACPElicitationRequest >> session [
	^ session
]

{ #category : #accessing }
GtLACPElicitationRequest >> session: anObject [
	session := anObject
]

{ #category : #accessing }
GtLACPElicitationRequest >> state [
	^ state
]

{ #category : #actions }
GtLACPElicitationRequest >> submit [
	self resolveAction: 'accept'
]

{ #category : #accessing }
GtLACPElicitationRequest >> toolCall [
	^ toolCall
]

{ #category : #accessing }
GtLACPElicitationRequest >> toolCall: anObject [
	toolCall := anObject
]

{ #category : #accessing }
GtLACPElicitationRequest >> turn [
	^ turn
]

{ #category : #accessing }
GtLACPElicitationRequest >> turn: anObject [
	turn := anObject
]

{ #category : #validation }
GtLACPElicitationRequest >> validateAnswers [
	| required |
	self isSupported ifFalse: [ self error: 'Unsupported question schema' ].
	required := self schema at: 'required' ifAbsent: [ #() ].
	self fields
		keysAndValuesDo: [ :key :field | 
			| value type options |
			value := self answerAt: key.
			((required includes: key)
				and: [ value isNil or: [ value isCollection and: [ value isEmpty ] ] ])
				ifTrue: [ self error: 'Please answer ' , (field at: 'title' ifAbsent: [ key ]) ].
			value
				ifNotNil: [ type := field at: 'type'.
					type = 'string'
						ifTrue: [ value isString ifFalse: [ self error: 'Expected text' ].
							value size < (field at: 'minLength' ifAbsent: [ 0 ])
								ifTrue: [ self error: 'Answer is too short' ].
							value size > (field at: 'maxLength' ifAbsent: [ value size ])
								ifTrue: [ self error: 'Answer is too long' ] ].
					(#('number' 'integer') includes: type)
						ifTrue: [ value isNumber ifFalse: [ self error: 'Expected a number' ].
							(type = 'integer' and: [ value isInteger not ])
								ifTrue: [ self error: 'Expected an integer' ].
							value < (field at: 'minimum' ifAbsent: [ value ])
								ifTrue: [ self error: 'Number is too small' ].
							value > (field at: 'maximum' ifAbsent: [ value ])
								ifTrue: [ self error: 'Number is too large' ] ].
					type = 'boolean'
						ifTrue: [ (#(true false) includes: value) ifFalse: [ self error: 'Expected a boolean' ] ].
					options := (self optionsFor: field)
							collect: [ :option | option at: 'const' ].
					type = 'array'
						ifTrue: [ (value isArray and: [ value allSatisfy: [ :each | options includes: each ] ])
								ifFalse: [ self error: 'Invalid multiple selection' ].
							value size < (field at: 'minItems' ifAbsent: [ 0 ])
								ifTrue: [ self error: 'Select more options' ].
							value size > (field at: 'maxItems' ifAbsent: [ value size ])
								ifTrue: [ self error: 'Select fewer options' ] ]
						ifFalse: [ (options notEmpty and: [ (options includes: value) not ])
								ifTrue: [ self error: 'Invalid selection' ] ] ] ]
]
