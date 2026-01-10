Class {
	#name : #GtLPlainObjectInputModel,
	#superclass : #GtLInputModel,
	#category : #Gt4LlmCore
}

{ #category : #'as yet unclassified' }
GtLPlainObjectInputModel >> addContentTo: aDictionary [
	aDictionary
		at: name
		put: {'class' -> model class name asString.
				'superclass'
					-> (model class superclass
							ifNil: [ nil ]
							ifNotNil: [ :aSuperclass | aSuperclass name ]).
				'package' -> model class package name.
				'printString'
					-> ([ model printString escapeCharacter: '''' ]
							on: Error
							do: [ :e | 'Error printing object' ]).
				'allInstanceMethods'
					-> (model
							ifNil: [ {} ]
							ifNotNil: [ model class methods asArray collect: [ :aMethod | aMethod selector ] ]).
				'instanceSlots'
					-> (model class allSlots
							collect: [ :aSlot | 
								| slotValue |
								slotValue := model readSlotNamed: aSlot name.
								{'name' -> aSlot name.
									'class' -> slotValue class asString.
									'value' -> (slotValue asString escapeCharacter: '''')} asDictionary ])
							asArray} asDictionary
]

{ #category : #'as yet unclassified' }
GtLPlainObjectInputModel >> addInstructionsTo: aMessageInstructions [

	aMessageInstructions
		addSection: (GtLlmInstructionSection new
				source: self;
				title: self name;
				body: '')
]
