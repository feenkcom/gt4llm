"
Group of package tag change histories.
"
Class {
	#name : #GtLPackageTagChangeHistoriesGroup,
	#superclass : #GtLChangeHistoriesGroup,
	#category : 'Gt4LlmCore-Summaries'
}

{ #category : #adding }
GtLPackageTagChangeHistoriesGroup >> addHistory: aHistory [
	self add: aHistory
]

{ #category : #views }
GtLPackageTagChangeHistoriesGroup >> gtViewHistoriesFor: aView [
	<gtView>
	
	^ aView columnedTree 
		title: 'By tag';
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
