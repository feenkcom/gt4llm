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
	^ {'class' -> aClass name.
		'superclass'
			-> (aClass superclass ifNil: [ nil ] ifNotNil: [ :aSuperclass | aSuperclass name ]).
		'comment' -> aClass instanceSide organization classComment.
		'package' -> aClass package name.
		'instanceSlots' -> aClass slotNames.
		'allInstanceMethods' -> (aClass methods asArray collect: [ :aMethod | aMethod selector ])} asDictionary
]

{ #category : #'as yet unclassified' }
GtLlmValueSerializer >> serializeValue: aValue [
	^ {'class' -> aValue class name asString.
		'superclass'
			-> (aValue class superclass ifNil: [ nil ] ifNotNil: [ :aSuperclass | aSuperclass name ]).
		'comment' -> aValue class instanceSide organization classComment.
		'package' -> aValue class package name.
		'printString' -> (aValue printString escapeCharacter: '''').
		'allInstanceMethods'
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
