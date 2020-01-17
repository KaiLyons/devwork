module main

import (
	ui
	gx
	os
)

const (
	w_width =  1100
	w_height = 600
	cell_h = 30
	cell_w = 150
	nr_cols = 5
	table_width = cell_w * nr_cols
)
struct Issues {
	issue_title        string
	issue_description  string
	issuer             string
	issue_tag          string
	issue_type         string
}

struct Modules {
mut:
	issue_title        &ui.TextBox
	issue_description  &ui.TextBox
	issuer             &ui.TextBox
	issue_type         &ui.Radio
	issue_tag          &ui.Radio
	window             &ui.Window
	issues             []Issues
}

fn main(){
	mut app := &Modules{
		issues: [Issues{
			issue_title: 'Title'
			issue_description: 'Description'
			issuer: 'Issuer'
			issue_tag: 'Tag'
			issue_type: 'Type'
		}]
	}

	window := ui.new_window({
		width: w_width
		height: w_height
		title: 'Devwork Demo'
		user_ptr: app
	})

	// The application features
	app.issue_title = ui.new_textbox({
		max_len: 20
		x: 10
		y: 10
		width: 220
		placeholder: 'Issue Title'
		parent: window
	})
	app.issue_description = ui.new_textbox({
		max_len: 20
		x: 10
		y: 40
		width: 220
		placeholder: 'Issue Description'
		parent: window
	})
	app.issuer = ui.new_textbox({
		max_len: 20
		x: 10
		y: 70
		width: 220
		placeholder: 'Your Name'
		parent: window
	})
	app.issue_tag = ui.new_radio({
		x: 10
		y: 100
		width: 220
		title: 'Issue Tag'
		values: ['Bug', 'Broken', 'Request', 'Idea']
		parent: window
	})
	app.issue_type = ui.new_radio({
		x: 10
		y: 230
		width: 220
		title: 'Issue Type'
		values: ['Open', 'Closed']
		parent: window
	})

	// UI Elements
	ui.new_button({
		parent: window
		x: 10
		y: 300
		text: 'Add issue'
		onclick: add_issue
	})
	ui.new_canvas({
		x: 200
		y: 20
		draw_fn:canvas_draw
		parent: window
	})

	app.window = window
	ui.run(window)
}

fn add_issue(app mut Modules) {
	new_issue := Issues{
		issue_title: app.issue_title.text
		issue_description: app.issue_description.text
		issuer: app.issuer.text
		issue_tag: app.issue_tag.selected_value()
		issue_type: app.issue_type.selected_value()
	}
	app.issues << new_issue
	app.issue_title.set_text('')
	app.issue_title.focus()
	app.issue_description.set_text('')
	app.issuer.set_text('')
}

fn canvas_draw(app &Modules) {
	gg := app.window.ui.gg
	mut ft := app.window.ui.ft
	x :=  280
	gg.draw_rect(x - 20, 0, table_width + 100, 800, gx.white)
	for i, issue in app.issues {
		y := 20 + i * cell_h
		// Outer border
		gg.draw_empty_rect(x, y, table_width, cell_h, gx.Gray)
		// Vertical separators
		gg.draw_line(x + cell_w, y, x + cell_w, y + cell_h, gx.Gray)
		gg.draw_line(x + cell_w * 2, y, x + cell_w * 2, y + cell_h, gx.Gray)
		gg.draw_line(x + cell_w * 3, y, x + cell_w * 3, y + cell_h, gx.Gray)
		gg.draw_line(x + cell_w * 4, y, x + cell_w * 4, y + cell_h, gx.Gray)
		// Text values
		ft.draw_text_def(x + 5, y + 5, issue.issue_title)
		ft.draw_text_def(x + 5 + cell_w * 1, y + 5, issue.issue_description)
		ft.draw_text_def(x + 5 + cell_w * 2, y + 5, issue.issuer)
		ft.draw_text_def(x + 5 + cell_w * 3, y + 5, issue.issue_tag)
		ft.draw_text_def(x + 5 + cell_w * 4, y + 5, issue.issue_type)
	}
}
