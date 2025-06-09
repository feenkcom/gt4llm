Class {
	#name : #GtLlmValueSerializer,
	#superclass : #Object,
	#category : #Gt4Llm
}

{ #category : #'as yet unclassified' }
GtLlmValueSerializer >> serializeBinding: aBinding withValue: aBindingValue [
	^ {'name' -> aBinding name.
		'bindingClass' -> aBinding class name asString.
		'value'
			-> (self serializeValue: aBindingValue)}
		asDictionary
]

{ #category : #'as yet unclassified' }
GtLlmValueSerializer >> serializeClass: aClass [
	^ {'name' -> aClass name.
		'superclass' -> aClass superclass name.
		'slots' -> aClass slotNames.
		'comment' -> aClass instanceSide organization classComment.
		'methods' -> (aClass allMethods collect: #selector)} asDictionary
]

{ #category : #'as yet unclassified' }
GtLlmValueSerializer >> serializeValue: aValue [
	^ {'class' -> aValue class name asString.
		'string' -> (aValue asString escapeCharacter: '''').
		'methods'
			-> (aValue
					ifNil: [ {} ]
					ifNotNil: [ aValue class methods asArray collect: [ :aMethod | aMethod selector ] ]).
		'instanceSlots'
			-> (aValue class allSlots
					collect: [ :aSlot | 
						| slotValue |
						slotValue := aValue readSlotNamed: aSlot name.
						{'name' -> aSlot name.
							'class' -> slotValue class asString.
							'value' -> (slotValue asString escapeCharacter: '''')} asDictionary ])
					asArray} asDictionary
]
