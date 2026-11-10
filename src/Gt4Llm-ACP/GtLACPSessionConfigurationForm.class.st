"
I describe advertised ACP configuration options as a Magritte form. Edits remain in the Magritte memento until Accept sends the changed values through ACP. Cancel discards pending edits. Agent responses refresh the available values and choices.
"
Class {
	#name : #GtLACPSessionConfigurationForm,
	#superclass : #Object,
	#instVars : [
		'session',
		'configOptions'
	],
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #actions }
GtLACPSessionConfigurationForm >> acceptMemento: aMemento [
	| changes |
	changes := aMemento magritteDescription children
			select: [ :description | 
				(aMemento readUsing: description)
					~= (self valueFor: (description propertyAt: #acpConfigId)) ].	"Apply model changes first because the agent can change dependent option choices."
	changes := (changes
			select: [ :description | (description propertyAt: #acpConfigId) = 'model' ])
			, (changes
					reject: [ :description | (description propertyAt: #acpConfigId) = 'model' ]).
	session
		ifNil: [ changes
				do: [ :description | 
					self
						value: (aMemento readUsing: description)
						for: (description propertyAt: #acpConfigId) ] ]
		ifNotNil: [ changes
				do: [ :description | 
					session
						setConfigOption: (description propertyAt: #acpConfigId)
						value: (aMemento readUsing: description) ].
			configOptions := session configOptions deepCopy ].
	^ aMemento reset
]

{ #category : #converting }
GtLACPSessionConfigurationForm >> asElement [
	^ self asGtMagritteViewModel asElement
		id: #'acp-configuration-form';
		padding: (BlInsets all: 5);
		yourself
]

{ #category : #magritte }
GtLACPSessionConfigurationForm >> basicMagritteDescription [
	| container models efforts ordered |
	container := MAContainer new.
	models := configOptions
			select: [ :option | 
				(option at: 'category' ifAbsent: [ '' ]) = 'model'
					or: [ (option at: 'id') = 'model' ] ].
	efforts := (configOptions copyWithoutAll: models)
			select: [ :option | 
				(option at: 'category' ifAbsent: [ '' ]) = 'thought_level'
					or: [ #('effort' 'reasoning_effort') includes: (option at: 'id') ] ].
	ordered := models , efforts , (configOptions copyWithoutAll: models , efforts).
	ordered
		withIndexDo: [ :option :index | 
			container
				add: ((self descriptionFor: option)
						priority: index;
						yourself) ].
	^ container
]

{ #category : #private }
GtLACPSessionConfigurationForm >> choicesIn: options [
	^ options
		flatCollect: [ :each | 
			(each includesKey: 'options')
				ifTrue: [ self choicesIn: (each at: 'options') ]
				ifFalse: [ {each} ] ]
]

{ #category : #accessing }
GtLACPSessionConfigurationForm >> configOptions [
	^ configOptions
]

{ #category : #accessing }
GtLACPSessionConfigurationForm >> configOptions: aCollection [
	configOptions := aCollection deepCopy
]

{ #category : #magritte }
GtLACPSessionConfigurationForm >> descriptionFor: option [
	| description choices anId |
	anId := option at: 'id'.
	(option at: 'type' ifAbsent: [ 'select' ]) = 'select'
		ifTrue: [ choices := self choicesIn: (option at: 'options' ifAbsent: [ #() ]).
			description := MASingleOptionDescription new
					options: (choices collect: [ :each | each at: 'value' ]);
					display: [ :value | 
						choices
							detect: [ :each | (each at: 'value') = value ]
							ifFound: [ :each | each at: 'name' ifAbsent: [ value asString ] ]
							ifNone: [ value asString ] ];
					yourself ]
		ifFalse: [ description := (option at: 'type') = 'boolean'
					ifTrue: [ MABooleanDescription new ]
					ifFalse: [ MAStringDescription new
							beReadOnly;
							yourself ] ].
	description
		propertyAt: #acpConfigId put: anId;
		labelAptitude: [ BrGlamorousLabelAptitude new
				foreground: Color gray;
				fontSize: 12 ];
		label: (option at: 'name' ifAbsent: [ anId ]);
		comment: (option at: 'description' ifAbsent: [ '' ]);
		accessor: (MAPluggableAccessor
				read: [ :model | model valueFor: anId ]
				write: [ :model :value | model value: value for: anId ]);
		autoAccept: false.
	(session notNil and: [ session isSubagent ]) ifTrue: [ description beReadOnly ].
	^ description
]

{ #category : #magritte }
GtLACPSessionConfigurationForm >> magritteAcceptAction [
	<magritteActionDescription>
	^ super magritteAcceptAction
		isLabelVisible: false;
		action: (GtMagritteAction new
				beInFutureProcess;
				beWithFutureResponse;
				action: [ :aModel :aButton :aMemento :aDescription | aModel acceptMemento: aMemento ]);
		yourself
]

{ #category : #accessing }
GtLACPSessionConfigurationForm >> session: aSession [
	session := aSession
]

{ #category : #private }
GtLACPSessionConfigurationForm >> value: aValue for: anId [
	(configOptions detect: [ :each | (each at: 'id') = anId ])
		at: 'currentValue'
		put: aValue
]

{ #category : #private }
GtLACPSessionConfigurationForm >> valueFor: anId [
	^ (configOptions detect: [ :each | (each at: 'id') = anId ])
		at: 'currentValue'
		ifAbsent: [ nil ]
]
