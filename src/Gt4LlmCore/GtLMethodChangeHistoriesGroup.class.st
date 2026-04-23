"
Group of method change histories.
"
Class {
	#name : #GtLMethodChangeHistoriesGroup,
	#superclass : #GtLChangeHistoriesGroup,
	#category : 'Gt4LlmCore-Summaries'
}

{ #category : #accessing }
GtLMethodChangeHistoriesGroup >> addHistory: aHistory [
	self add: aHistory
]

{ #category : #'gt-extensions' }
GtLMethodChangeHistoriesGroup >> gtViewHistoriesFor: aView [
	<gtView>
	^ aView columnedTree 
		title: 'By method';
		priority: 20;
		items: [ self items ];
		children: [ :anEntry | anEntry gtViewChangeHistoryChildren ];
		column: 'Change' do: [ :aColumn |
			aColumn
				cellStencil: [ GtLCodeChangesDetailsElement new ];
				dataBinder: [ :anElement :aCodeChange | anElement codeChange: aCodeChange ] ];
		column: 'Count' text: [ :anEntry | 
			| entryChangesCount |
			entryChangesCount := anEntry gtViewChangesCount.
			entryChangesCount isZero 
				ifTrue: ['']
				ifFalse: [
					entryChangesCount asString
						, ' '
							, ('change' asPluralBasedOn: entryChangesCount) ]] width: 100;
		column: 'Timestamp' text: [ :anEntry | 
			anEntry gtViewChangeEditTime
				ifNil: ['']
				ifNotNil: [ :aDateAndTime | 
					aDateAndTime printToSeconds ]  ] width: 150
]
