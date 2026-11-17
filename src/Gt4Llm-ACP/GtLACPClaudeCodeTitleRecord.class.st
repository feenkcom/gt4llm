"
I am title evidence. I explain my title, precedence and eligibility. Explicit titles precede generated titles; the latest equally ranked record wins.
"
Class {
	#name : #GtLACPClaudeCodeTitleRecord,
	#superclass : #GtLACPClaudeCodeTranscriptRecord,
	#category : #'Gt4Llm-ACP-Session discovery'
}

{ #category : #'gt - views' }
GtLACPClaudeCodeTitleRecord >> gtSelectionFor: aView [
	"Why is this title candidate selected or excluded?"

	<gtView>
	^ aView columnedList
		title: 'Selection';
		priority: -10;
		items: [ {'Title' -> self title.
				'Field' -> self titleField.
				'Priority' -> self priority.
				'Decision' -> self selectionReason.
				'File' -> file.
				'Line' -> lineNumber} ];
		column: 'Property' text: #key;
		column: 'Value' text: [ :entry | entry value asString ];
		send: #value
]

{ #category : #accessing }
GtLACPClaudeCodeTitleRecord >> isTitleRecord [
	^ true
]

{ #category : #accessing }
GtLACPClaudeCodeTitleRecord >> isUsable [
	^ self belongsToSession
		and: [ self title isString and: [ self title trimBoth notEmpty ] ]
]

{ #category : #accessing }
GtLACPClaudeCodeTitleRecord >> priority [
	self titleField = 'customTitle'
		ifTrue: [ ^ lineNumber ifNil: [ 35 ] ifNotNil: [ 40 ] ].
	self titleField = 'aiTitle' ifTrue: [ ^ 30 ].
	self titleField = 'summary' ifTrue: [ ^ 20 ].
	^ 10
]

{ #category : #accessing }
GtLACPClaudeCodeTitleRecord >> selectionReason [
	self belongsToSession ifFalse: [ ^ 'Different session' ].
	self isUsable ifFalse: [ ^ 'Missing or invalid text' ].
	(self sameLocationAs: session selectedTitleRecord) ifTrue: [ ^ 'Selected' ].
	self priority < session selectedTitleRecord priority
		ifTrue: [ ^ 'Lower priority' ].
	^ 'Superseded by later record'
]

{ #category : #accessing }
GtLACPClaudeCodeTitleRecord >> title [
	^ rawData at: self titleField
]

{ #category : #accessing }
GtLACPClaudeCodeTitleRecord >> titleField [
	^ self class titleFields detect: [ :key | rawData includesKey: key ]
]
