Class {
	#name : #GtLConnection,
	#superclass : #Object,
	#instVars : [
		'label',
		'providerClass',
		'configurationOptions'
	],
	#category : #'Gt4LlmCore-Core'
}

{ #category : #comparing }
GtLConnection >> = anotherConnection [
	^ anotherConnection class = self class
		and: [ self model = anotherConnection model
				and: [ self providerClass = anotherConnection providerClass ] ]
]

{ #category : #adding }
GtLConnection >> addOption: aConnectionConfigurationOption [

	(configurationOptions anySatisfy: [ :option |
		option name = aConnectionConfigurationOption name ]) ifTrue:
			[ self error: 'Duplicate configuration name: ', aConnectionConfigurationOption name asString ].

	configurationOptions add: aConnectionConfigurationOption.
]

{ #category : #adding }
GtLConnection >> addOption: anOption withValue: aValue [
	"Legacy interface - this assumes anOption is the name of a single argument selector"

	self addOption: (GtLConnectionPropertyConfigurationOption
		name: anOption
		selector: anOption asSymbol asMutator
		valueGenerator: [ { aValue } ])
]

{ #category : #accessing }
GtLConnection >> applyConfigurationOptionsTo: aProvider [

	configurationOptions do: [ :option |
		option applyOn: aProvider ].
]

{ #category : #accessing }
GtLConnection >> buildBareProvider [
	"use this for more flexible setup, such as in examples"
	| aProvider |
	aProvider := self providerClass new.
	self applyConfigurationOptionsTo: aProvider.
	^ aProvider
]

{ #category : #accessing }
GtLConnection >> buildProvider [
	| aProvider |
	aProvider := self providerClass withDefaultSetup.
	self applyConfigurationOptionsTo: aProvider.
	^ aProvider
]

{ #category : #accessing }
GtLConnection >> connectionProviderClass: aClass [
	providerClass := aClass
]

{ #category : #accessing }
GtLConnection >> connectionString [
	^ self label ifNil: [ self model ]
]

{ #category : #accessing }
GtLConnection >> details [
	^ {'Provider' -> self providerClass providerName.
		'Model' -> self model.
		'Label' -> self label}
]

{ #category : #'gt - extensions' }
GtLConnection >> gtActionSpawnProviderFor: anAction [
	<gtAction>
	^ anAction button
		icon: BrGlamorousVectorIcons playinspect;
		label: 'Provider';
		priority: 10;
		action: [ :aButton | aButton phlow spawnObject: self buildProvider ]
]

{ #category : #'gt - extensions' }
GtLConnection >> gtDetailsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Details';
		priority: 10;
		items: [ self details ];
		column: 'Property' text: #key;
		column: 'Value' text: #value
]

{ #category : #'gt - extensions' }
GtLConnection >> gtDisplayOn: stream [
	stream
		nextPutAll: 'Connection: ';
		nextPutAll: self providerClass providerName;
		space;
		nextPutAll: self model;
		space;
		nextPutAll: (self isConnectable ifTrue: [ 'connectable' ] ifFalse: [ 'not connectable' ])
]

{ #category : #'gt - extensions' }
GtLConnection >> gtOptionsFor: aView [
	<gtView>
	^ aView list
		title: 'Options';
		priority: 2;
		items: [ configurationOptions ]
]

{ #category : #comparing }
GtLConnection >> hash [
	^ (self class hash hashMultiply bitXor: self model hash hashMultiply)
		bitXor: self providerClass hash hashMultiply
]

{ #category : #initialization }
GtLConnection >> initialize [
	super initialize.
	
	configurationOptions := OrderedCollection new
]

{ #category : #testing }
GtLConnection >> isConnectable [
	^ self providerClass isConnectable
]

{ #category : #accessing }
GtLConnection >> label [
	^ label
]

{ #category : #accessing }
GtLConnection >> label: anObject [
	label := anObject
]

{ #category : #accessing }
GtLConnection >> model [
	^ self modelName
]

{ #category : #accessing }
GtLConnection >> model: aString [
	self modelName: aString
]

{ #category : #accessing }
GtLConnection >> modelName [
	^ (self optionNamed: #modelName) values first
]

{ #category : #accessing }
GtLConnection >> modelName: anObject [
	self addOption: #modelName withValue: anObject
]

{ #category : #accessing }
GtLConnection >> optionNamed: aString [

	^ configurationOptions detect: [ :each |
			each name = aString ]
]

{ #category : #accessing }
GtLConnection >> optionNamed: aString ifAbsent: absentBlock [

	^ configurationOptions 
		detect: [ :each | each name = aString ]
		ifNone: absentBlock
]

{ #category : #accessing }
GtLConnection >> providerClass [
	^ providerClass
]

{ #category : #accessing }
GtLConnection >> providerClass: aClass [
	providerClass := aClass
]

{ #category : #accessing }
GtLConnection >> providerName [
	^ self providerClass providerName
]
