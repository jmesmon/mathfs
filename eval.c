/*
 * Cody Schafer <cpschafer@gmail.com>
 * Michael Koval <koval.michael@gmail.com>
 */
#include "eval.h"
#include "error.h"

error_t eval(plist_t *head)
{
	plist_t *ptr = head->prev;
	error_t  err = ERR_NONE;

	while (ptr != head && err == ERR_NONE) {
		item_t *item = item_entry(ptr);

		switch (item->type) {
		case TT_OP:
			err = item->op_e->func(ptr, head);
			ptr = ptr->prev;
			plist_pop(ptr);
			item_destroy(item);
			break;

		case TT_NUM:
			ptr = ptr->prev;
			break;

		case TT_UNK:
			err = ERR_UNDEF_OP;
			break;
		}
	}
	return err;
}
