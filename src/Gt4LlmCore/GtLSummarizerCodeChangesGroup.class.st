"
Group of summarizer code changes with dedicated views.
"
Class {
	#name : #GtLSummarizerCodeChangesGroup,
	#superclass : #GtBasicGroup,
	#category : #'Gt4LlmCore-Summaries'
}

{ #category : #'gt-extensions' }
GtLSummarizerCodeChangesGroup >> gtCodeChangesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Code changes';
		priority: 10;
		items: [ self items ];
		column: 'Change' do: [ :aColumn |
			aColumn
				cellStencil: [ GtLCodeChangesDetailsElement new ];
				dataBinder: [ :anElement :aCodeChange | anElement codeChange: aCodeChange ] ];
		column: 'Tool' text: [ :each | each toolCall name asString ] width: 200
]

{ #category : #accessing }
GtLSummarizerCodeChangesGroup >> initialChange [
	^self first
]

{ #category : #accessing }
GtLSummarizerCodeChangesGroup >> latestChange [
	^self last
]
