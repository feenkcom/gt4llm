"
Group of summarizer code changes with dedicated views.
"
Class {
	#name : #GtLSummarizerCodeChangesGroup,
	#superclass : #GtBasicGroup,
	#category : 'Gt4LlmCore-Summaries'
}

{ #category : #'gt-extensions' }
GtLSummarizerCodeChangesGroup >> gtCodeChangesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Code changes';
		priority: 10;
		items: [ self items ];
		column: 'Class'
			stencil: [ :each | 
				BrExpander new
					vFitContent;
					hMatchParent;
					padding: (BlInsets all: 0);
					margin: (BlInsets top: 5 left: 0 bottom: 5 right: 5);
					collapse;
					aptitude: (GtCoderExpanderAptitude new "sidebarExtraPadding: (BlInsets top: 5)");
					header: [ 
						GtLCodeChangesDetailsElement new
							codeChange: each ];
					content: [ each asDiffElement ] ]
		"column: 'Change' do: [ :aColumn |
			aColumn
				cellStencil: [ GtLCodeChangesDetailsElement new ];
				dataBinder: [ :anElement :aCodeChange | anElement codeChange: aCodeChange ] ];"
		"column: 'Tool' text: [ :each | each toolCall name asString ] width: 200"
	
]

{ #category : #'gt-extensions' }
GtLSummarizerCodeChangesGroup >> gtCodeChangesListFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Code changes (details)';
		priority: 10.5;
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
