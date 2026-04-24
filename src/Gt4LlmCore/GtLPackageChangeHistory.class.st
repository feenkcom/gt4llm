"
I track changes to a single package, including its classes and methods.

Instance variables:
- `targetPackageName` - the name of the package being tracked
- `classHistories` - a {{gtClass:GtLClassChangeHistoriesGroup}} containing class histories

See also:
- {{gtClass:GtEpiceaPackageHistory}} - similar concept in Epicea
"
Class {
	#name : #GtLPackageChangeHistory,
	#superclass : #GtLEntityChangeHistory,
	#instVars : [
		'targetPackageName',
		'classHistories'
	],
	#category : 'Gt4LlmCore-Summaries'
}

{ #category : #adding }
GtLPackageChangeHistory >> addClassHistories: aClassHistoriesGroup [
	"Add multiple class histories"
	aClassHistoriesGroup items do: [ :each |
		self addClassHistory: each ]
]

{ #category : #adding }
GtLPackageChangeHistory >> addClassHistory: aClassHistory [
	self classHistories addHistory: aClassHistory
]

{ #category : #accessing }
GtLPackageChangeHistory >> changes [
	"Return all changes from all class histories"
	| allChanges |
	allChanges := GtLSummarizerCodeChangesGroup new.
	self classHistories items do: [ :classHistory |
		allChanges addAll: classHistory changes ].
	^ allChanges
]

{ #category : #accessing }
GtLPackageChangeHistory >> classHistories [
	^ classHistories
]

{ #category : #printing }
GtLPackageChangeHistory >> gtDisplayOn: aStream [
	aStream nextPutAll: self targetPackageName
]

{ #category : #views }
GtLPackageChangeHistory >> gtViewChangeDescriptionElement [
	^ BlTextElement new 
		padding: (BlInsets all: 0);
		constraintsDo: [ :c | 
			c linear vertical alignCenter ];
		text: (self targetPackageName asRopedText 
			bold; 
			glamorousRegularFont)
]

{ #category : #views }
GtLPackageChangeHistory >> gtViewChangeEditTime [
	"Return the latest edit time across all class changes"
	| times |
	times := OrderedCollection new.
	self classHistories items do: [ :each | 
		each gtViewChangeEditTime ifNotNil: [ :t | times add: t ] ].
	^ times ifEmpty: [ nil ] ifNotEmpty: [ times max ]
]

{ #category : #views }
GtLPackageChangeHistory >> gtViewChangeHistoryChildren [
	^ self classHistories items
]

{ #category : #views }
GtLPackageChangeHistory >> gtViewChangeIcon [
	self hasNoEffect ifTrue: [
		^ Smalltalk ui icons iconNamed: #emptyPackage ].
		
	^ Smalltalk ui icons iconNamed: #package
]

{ #category : #views }
GtLPackageChangeHistory >> gtViewChangesCount [
	^ self classHistories items
		inject: 0
		into: [ :sum :each | sum + each gtViewChangesCount ]
]

{ #category : #views }
GtLPackageChangeHistory >> gtViewClassHistoriesFor: aView [
	<gtView>
	
	^ aView forward 
		title: 'By class';
		priority: 35;
		object: [ self classHistories ];
		view: #gtViewHistoriesFor:
]

{ #category : #testing }
GtLPackageChangeHistory >> hasNoEffect [
	^ self classHistories items allSatisfy: #hasNoEffect
]

{ #category : #initialization }
GtLPackageChangeHistory >> initialize [
	super initialize.
	classHistories := GtLClassChangeHistoriesGroup new
]

{ #category : #accessing }
GtLPackageChangeHistory >> targetPackageName [
	^ targetPackageName
]

{ #category : #accessing }
GtLPackageChangeHistory >> targetPackageName: aPackageName [
	targetPackageName := aPackageName
]
