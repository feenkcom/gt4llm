"
Specification describing how to build and update a tool call summarizer for a group of messages.
"
Class {
	#name : #GtLToolCallSummarizerSpecification,
	#superclass : #Object,
	#instVars : [
		'id',
		'summarizerClassName',
		'isActive'
	],
	#category : #'Gt4LlmCore-Summaries'
}

{ #category : #'instance creation' }
GtLToolCallSummarizerSpecification class >> forSummarizerClass: aClass [
	^ self new
		initializeFromSummarizerClass: aClass;
		yourself
]

{ #category : #building }
GtLToolCallSummarizerSpecification >> buildForMessages: aMessagesGroup [
	^ self summarizerClass new
			summarizerSpecification: self;
			initializeWithMessages: aMessagesGroup;
			yourself
]

{ #category : #'gt-views' }
GtLToolCallSummarizerSpecification >> gtDetailsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Details';
		priority: 5;
		items: [ {
			'Id' -> self id.
			'Summarizer' -> self summarizerClassName.
			'Active' -> self isActive } ];
		column: 'Property' text: [ :each | each key ];
		column: 'Value' text: [ :each | each value ]
]

{ #category : #accessing }
GtLToolCallSummarizerSpecification >> id [
	^ id
]

{ #category : #accessing }
GtLToolCallSummarizerSpecification >> id: anObject [
	id := anObject
]

{ #category : #initialization }
GtLToolCallSummarizerSpecification >> initialize [
	super initialize.
	
	isActive := true
]

{ #category : #initialization }
GtLToolCallSummarizerSpecification >> initializeFromSummarizerClass: aClass [
	summarizerClassName := aClass name.
	id := aClass name.
	isActive := aClass isActive
]

{ #category : #accessing }
GtLToolCallSummarizerSpecification >> isActive [
	^ isActive
]

{ #category : #testing }
GtLToolCallSummarizerSpecification >> isApplicableToMessages: aMessagesGroup [
	^ self isActive and: [
			self class environment hasClassOrTraitNamed: self summarizerClassName ]
]

{ #category : #testing }
GtLToolCallSummarizerSpecification >> matchesSummarizer: aSummarizer [
	^ aSummarizer summarizerSpecification notNil
		and: [ aSummarizer summarizerSpecification id = self id ]
]

{ #category : #printing }
GtLToolCallSummarizerSpecification >> printOn: aStream [
	aStream nextPutAll: self summarizerClassName
]

{ #category : #accessing }
GtLToolCallSummarizerSpecification >> summarizerClass [
	^ self class environment at: self summarizerClassName asSymbol
]

{ #category : #accessing }
GtLToolCallSummarizerSpecification >> summarizerClassName [
	^ summarizerClassName
]
