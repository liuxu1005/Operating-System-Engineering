Test Result:

running JOS: (0.9s) 
  Physical page allocator: OK 
  Page management: OK 
  Kernel page directory: OK 
  Page management 2: OK 
Score: 70/70

Code:

Exercise 1. In the file kern/pmap.c, you must implement code for the following functions (probably in the order given).

fragment of boot_alloc
// LAB 2: Your code here.
        if (n > 0) {
		// Round-up alloc_size promises round-up nextfree.
		uint32_t alloc_size = ROUNDUP(n, PGSIZE);

		result = nextfree;
		nextfree += alloc_size;

		// Because in the beginning phase of booting,
		// only 4MB physical memory is mapped.
		// Memory allocation cannot exceeds the limit.
		if ((uint32_t)nextfree >= 0xf0400000) {
		     nextfree = result;
                     result = NULL;
                     panic("boot_alloc: out of memory");
                }

        
	} else {
		result = nextfree;
	}
	return result;
	
fragment of mem_init
// Your code goes here:
        boot_map_region(kern_pgdir, UPAGES, PTSIZE, PADDR(pages), PTE_U);
 
	// Your code goes here:
        boot_map_region(kern_pgdir, KSTACKTOP-KSTKSIZE, KSTKSIZE, PADDR(bootstack), PTE_W);

fragment of page_init

size_t i;
	for (i = 0; i < npages; i++) {
		pages[i].pp_ref = 0;
		pages[i].pp_link = page_free_list;
		page_free_list = &pages[i];
	}
        pages[0].pp_ref = 1;
  
        pages[1].pp_link = pages[0].pp_link;
        
        uint32_t nextfreepa = PADDR(boot_alloc(0)); 
        
        void *p = pages[IOPHYSMEM/PGSIZE].pp_link;
        for (i = IOPHYSMEM; i < nextfreepa; i += PGSIZE) { 
              pages[i/PGSIZE].pp_ref = 1;  
              pages[i/PGSIZE].pp_link = NULL;     
        }      
        pages[i/PGSIZE].pp_link = p;