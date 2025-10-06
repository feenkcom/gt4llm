Class {
	#name : #GtLlmActionCallExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-Examples'
}

{ #category : #'as yet unclassified' }
GtLlmActionCallExamples >> actionCall [
	<gtExample>
	| actionCall serialized unserialized |
	actionCall := GtLlmActionCall new.
	serialized := actionCall serialize.
	self assert: serialized isString.
	unserialized := STONJSON fromString: serialized.
	self assert: unserialized isDictionary.
	self assert: unserialized size equals: 2.
	self assert: (unserialized at: 'Action') isNil.
	self assert: (unserialized at: 'Arguments') isEmpty.
	^ actionCall
]

{ #category : #'as yet unclassified' }
GtLlmActionCallExamples >> actionCallWithName [
	<gtExample>
	| actionCall serialized unserialized |
	actionCall := self actionCall.
	actionCall action: 'Some action name'.
	serialized := actionCall serialize.
	self assert: serialized isString.
	unserialized := STONJSON fromString: serialized.
	self assert: unserialized isDictionary.
	self assert: unserialized size equals: 2.
	self assert: (unserialized at: 'Action') equals: 'Some action name'.
	self assert: (unserialized at: 'Arguments') isEmpty.
	^ actionCall
]

{ #category : #'as yet unclassified' }
GtLlmActionCallExamples >> actionCallWithNameAndArguments [
	<gtExample>
	| actionCall serialized unserialized |
	actionCall := self actionCallWithName.
	actionCall arguments: {'Arg1' . 'Arg2'}.
	serialized := actionCall serialize.
	self assert: serialized isString.
	unserialized := STONJSON fromString: serialized.
	self assert: unserialized isDictionary.
	self assert: unserialized size equals: 2.
	self assert: (unserialized at: 'Action') equals: 'Some action name'.
	self assert: (unserialized at: 'Arguments') size equals: 2.
	self assert: (unserialized at: 'Arguments') first equals: 'Arg1'.
	self assert: (unserialized at: 'Arguments') last equals: 'Arg2'.
	^ actionCall
]
