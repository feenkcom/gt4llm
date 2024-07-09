Class {
	#name : #GtLlmEsugSlideshow,
	#superclass : #PrioritySlideshow,
	#category : #'Gt4Llm-Presentations'
}

{ #category : #accessing }
GtLlmEsugSlideshow >> agenda: aSlide [
	<gtSlide>
	^ aSlide paragraph
		setPriority;
		subtitleWithFormat: (self asSubtitle: 'Agenda');
		paragraph: '1.' asRopedText bold
				, ' Working with ' asRopedText, 'OpenAI' asRopedText italic, ' and ' asRopedText, 'Ollama' asRopedText italic, ' in GT
' asRopedText , '2.' asRopedText bold
				, ' The actual workbench
' asRopedText, '3.' asRopedText bold , ' A case study' asRopedText
]

{ #category : #accessing }
GtLlmEsugSlideshow >> gt4openAiBooklet: aSlide [
	<gtSlide>
	^ aSlide lepiterPage
		setPriority;
		startPage: ((LeDatabase databaseNamed: 'gt4llm-lepiter')
				pageNamed: 'gt4openai: working with OpenAI')
]

{ #category : #accessing }
GtLlmEsugSlideshow >> slidePriorities [
	"Instead of manually setting priorities, just list the slides in order here."

	<gtExample>
	^ #(#title:
		#agenda:
		#gt4openAiBooklet:
		#thankYou:
		)
]

{ #category : #accessing }
GtLlmEsugSlideshow >> thankYou: aSlide [
	<gtSlide>
	^ aSlide titleWithFooter
		setPriority;
		titleBottomPadding: 30;
		subtitleBottomPadding: 40;
		titleWithFormat: (self asTitle: 'Thank you!');
		subtitleWithFormat: (self asTitle: 'Questions?');
		footerWithFormat: (self asBigText: 'https://github.com/feenkcom/gt4llm')
]

{ #category : #accessing }
GtLlmEsugSlideshow >> title: aSlide [
	<gtSlide>
	^ aSlide titleWithFooter
		setPriority;
		titleBottomPadding: 30;
		subtitleBottomPadding: 40;
		titleWithFormat: (self asTitle: 'gt4llm');
		subtitleWithFormat: (self asSubtitle: 'Software Development with LLMs in Glamorous Toolkit');
		footerWithFormat: (self asBigText: 'veit.heller@feenk.com')
]
